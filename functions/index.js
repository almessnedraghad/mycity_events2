
/*const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });*/

const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp();


// NEW EVENT NOTIFICATION
exports.newEventNotification = functions.firestore
    .document("events/{eventId}")
    .onUpdate(async (change, context) => {

      const before = change.before.data();
      const after = change.after.data();

      if (
        before.approvalStatus !== "approved" &&
        after.approvalStatus === "approved"
      ) {

        const message = {
          notification: {
            title: "New Event",
            body: `${after.title} is now available`,
          },

          topic: "allUsers",
        };

        await admin.messaging().send(message);

        console.log("New event notification sent");
      }
    });


// EVENT REMINDER
exports.sendEventReminder = functions.pubsub
    .schedule("every 1 minutes")
    .onRun(async (context) => {

      const snapshot = await admin.firestore()
          .collection("events")
          .where("approvalStatus", "==", "approved")
          .get();

      const now = new Date();

      for (const doc of snapshot.docs) {

        const data = doc.data();

        if (!data.date) continue;

        let eventDate;

        if (data.date.toDate) {
          eventDate = data.date.toDate();
        } else {
          eventDate = new Date(data.date);
        }

        const diffTime = eventDate - now;

        const diffDays =
          Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        if (diffDays === 1) {

          const message = {
            notification: {
              title: "Reminder",
              body: `${data.title} is tomorrow`,
            },

            topic: "allUsers",
          };

          await admin.messaging().send(message);

          console.log("Reminder sent:", data.title);
        }
      }

      return null;
    });
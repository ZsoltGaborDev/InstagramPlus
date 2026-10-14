// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const {onDocumentCreated, onDocumentDeleted} = require("firebase-functions/firestore");

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

initializeApp();

exports.updateUserFeedAfterFollow = onDocumentCreated("/following/{currentUid}/user-following/{followedUid}", async (event) => {
    const currentUid = event.params.currentUid;
    const followedUid = event.params.followedUid;
    const db = getFirestore();

    try {
        const snapshot = await db.collection("posts").where("ownerUid", "==", followedUid).get();
        snapshot.forEach((doc) => {
            const postId = doc.id;
            const userFeedRef = db.collection("users").doc(currentUid).collection("user-feed").doc(postId);
            userFeedRef.set({});
        })
    } catch (err) {
        logger.error("Error updating feed after follow");
        throw err;
    }
})

exports.updateUserFeedAfterUnfollow = onDocumentDeleted("/following/{currentUid}/user-following/{unfollowedUid}", async (event) => {
    const currentUid = event.params.currentUid;
    const unfollowedUid = event.params.unfollowedUid;
    const db = getFirestore();

    try {
        const snapshot = await db.collection("posts").where("ownerUid", "==", unfollowedUid).get();
        snapshot.forEach((doc) => {
            const postId = doc.id;
            const userFeedRef = db.collection("users").doc(currentUid).collection("user-feed").doc(postId);
            userFeedRef.delete();
        })
    } catch (err) {
        logger.error("Error updating feed after unfollow");
        throw err;
    }
})

exports.updateUserFeedAfterPost = onDocumentCreated("/posts/{postId}",async (event) => {
        const postId = event.params.postId;
        const db = getFirestore();

        try {
            
            const data = event.data.data();
            const ownerUid = data.ownerUid;

            const ownerFeedRef = db.collection("users")
                .doc(ownerUid).collection("user-feed").doc(postId);

            await ownerFeedRef.set({});

            const followerSnapshot = await db.collection("followers")
                .doc(ownerUid).collection("user-followers").get();

            await Promise.all(followerSnapshot.docs.map((doc) =>
                db.collection("users").doc(doc.id)
                    .collection("user-feed").doc(postId).set({})
            ));
        } catch (err) {
            logger.error("Error updating user feed after post", err);
            throw err;
        }
    }
);


// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /messages/:documentId/original
exports.addmessage = onRequest(async (req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into Firestore using the Firebase Admin SDK.
  const writeResult = await getFirestore()
      .collection("messages")
      .add({original: original});
  // Send back a message that we've successfully written the message
  res.json({result: `Message with ID: ${writeResult.id} added.`});
});

// Listens for new messages added to /messages/:documentId/original
// and saves an uppercased version of the message
// to /messages/:documentId/uppercase
exports.makeuppercase = onDocumentCreated("/messages/{documentId}", (event) => {
  // Grab the current value of what was written to Firestore.
  const original = event.data.data().original;

  // Access the parameter `{documentId}` with `event.params`
  logger.log("Uppercasing", event.params.documentId, original);

  const uppercase = original.toUpperCase();

  // You must return a Promise when performing
  // asynchronous tasks inside a function
  // such as writing to Firestore.
  // Setting an 'uppercase' field in Firestore document returns a Promise.
  return event.data.ref.set({uppercase}, {merge: true});
});
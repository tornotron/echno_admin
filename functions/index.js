/* eslint-disable object-curly-spacing */
/* eslint-disable require-jsdoc */
const { onSchedule } = require("firebase-functions/v2/scheduler");
// const { logger } = require("firebase-functions");

const admin = require("firebase-admin");
const { setGlobalOptions } = require("firebase-functions/v2");
admin.initializeApp();

const firestore = admin.firestore();

setGlobalOptions({ region: "asia-south1" });

async function createDocument(collectionName, documentData) {
  try {
    const docref = await firestore.collection(collectionName).add(documentData);
    return docref.id;
  } catch (err) {
    console.error("Error adding document: ", err);
    throw err;
  }
}

const collectionName = "testcoll";
const documentData = {
  field1: "testvalue1",
  field2: "testvalue",
};

exports.scheduleLeaveMarking = onSchedule("* * * * *", async (context) => {
  try {
    await createDocument(collectionName, documentData);
    console.log("Document created successfully");
  } catch (error) {
    console.error("Error creating document: ", error);
  }
});


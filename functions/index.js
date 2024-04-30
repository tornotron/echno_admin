/* eslint-disable max-len */
/* eslint-disable object-curly-spacing */
/* eslint-disable require-jsdoc */
const { onSchedule } = require("firebase-functions/v2/scheduler");
// const { logger } = require("firebase-functions");

const admin = require("firebase-admin");
const { setGlobalOptions } = require("firebase-functions/v2");
admin.initializeApp();

const firestore = admin.firestore();

setGlobalOptions({ region: "asia-south1" });

async function createDocument(collectionName, empId, formattedDate) {
  try {
    await firestore.collection(collectionName).doc(empId).collection("attendancedate").doc(formattedDate).set({
      "attendance-status": "false",
    });
    console.log("Document created");
  } catch (err) {
    console.error("Error adding document: ", err);
    throw err;
  }
}

async function checkforAttendanceMarking() {
  const currentDate = new Date();
  const year = currentDate.getFullYear();
  const month = String(currentDate.getMonth() + 1).padStart(2, "0");
  const day = String(currentDate.getDate()).padStart(2, "0");
  const formattedDate = `${year}-${month}-${day}`;
  const collectionName = "attendance";
  const empId = "EMP-000004";
  try {
    await firestore.collection(collectionName).doc(empId).collection("attendancedate").doc(formattedDate).get().then(async (doc)=>{
      if (!doc.exists) {
        await createDocument(collectionName, empId, formattedDate);
      } else {
        console.log("Document already exists");
      }
    });
  } catch (err) {
    console.error(err);
    throw err;
  }
}


exports.scheduleLeaveMarking = onSchedule("* * * * *", async (context) => {
  try {
    await checkforAttendanceMarking();
  } catch (error) {
    console.error("Error creating document: ", error);
  }
});

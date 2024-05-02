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

async function fetchEmployeeList() {
  try {
    const snapshot = await firestore.collection("attendance").get();
    const documentNames = snapshot.docs.map((doc) => doc.id);
    return documentNames;
  } catch (error) {
    console.error("Error fetching employee list:", error);
    throw error;
  }
}


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

async function checkforAttendanceMarking(empList) {
  const currentDate = new Date();
  const year = currentDate.getFullYear();
  const month = String(currentDate.getMonth() + 1).padStart(2, "0");
  const day = String(currentDate.getDate()).padStart(2, "0");
  const formattedDate = `${year}-${month}-${day}`;
  const collectionName = "attendance";
  for (let i = 0; i < empList.length; i++) {
    try {
      await firestore.collection(collectionName).doc(empList[i]).collection("attendancedate").doc(formattedDate).get().then(async (doc)=>{
        if (!doc.exists) {
          await createDocument(collectionName, empList[i], formattedDate);
        } else {
          console.log("Document already exists");
        }
      });
    } catch (err) {
      console.error(err);
      throw err;
    }
  }
}


exports.scheduleLeaveMarking = onSchedule("0 10 * * *", async (context) => {
  try {
    const empList = await fetchEmployeeList();
    await checkforAttendanceMarking(empList);
  } catch (error) {
    console.error("Error creating document: ", error);
  }
});

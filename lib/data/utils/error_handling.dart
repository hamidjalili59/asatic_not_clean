import 'printf.dart';

void handlingErr(
    {String statusCode = "", String phoneNumberID = "", String pass = ""}) {
  var errCode = (statusCode.toString().substring(
      statusCode.toString().length - 4, statusCode.toString().length - 1));
  switch (errCode) {
    case "400":
      printF(text: "hamid err400 switch handel $statusCode");
      break;
    case "401":
      printF(text: "hamid err401 switch handel $statusCode");
      break;
    case "402":
      printF(text: "hamid err402 switch handel $statusCode");
      break;
    case "403":
      printF(text: "hamid err403 switch handel $statusCode");
      break;
    case "404":
      printF(text: "hamid err404 switch handel $statusCode");
      // printF(text: "Creating Document .... ");
      // ApiServices().createDocument(email: AppWriteConstants.email, userID: AppWriteConstants.phoneNumberID);
      break;
    case "407":
      printF(text: "hamid err407 switch handel $statusCode");
      break;
    case "408":
      printF(text: "hamid err408 switch handel $statusCode");
      break;
    case "409":
      printF(text: "hamid err409 switch handel $statusCode");
      // printF(text: "Logining .... ");
      break;
    case "429":
      printF(text: "hamid err429 switch handel $statusCode");
      // printF(text: "Logining .... ");

      break;
    default:
      printF(text: "hamid default shod switch handel $statusCode");
  }
}

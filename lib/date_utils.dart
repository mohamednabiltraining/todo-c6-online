/***
 * to extract only date from date time
 */
DateTime dateOnly(DateTime inputDateTime){
  return DateTime(inputDateTime.year,inputDateTime.month,inputDateTime.day);
}
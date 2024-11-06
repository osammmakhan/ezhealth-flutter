// class TicketGenerator {
//   static final TicketGenerator _instance = TicketGenerator._internal();

//   factory TicketGenerator() {
//     return _instance;
//   }

//   TicketGenerator._internal();

//   String generateReferenceNumber() {
//     final now = DateTime.now();
//     final year = now.year.toString().substring(2);
//     final date = '$year${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
//     final random = (100 + DateTime.now().millisecondsSinceEpoch % 900).toString();
//     return 'REF-$date-$random';
//   }

//   String generateTicketToken() {
//     final random = (10 + DateTime.now().second) % 99;
//     return 'TKT-${random.toString().padLeft(2, '0')}';
//   }

//   bool validateTicket(String token) {
//     if (token.isEmpty) return false;

//     final parts = token.split('-');
//     if (parts.length != 3 || parts[0] != 'TKT') return false;

//     return true;
//   }
// }

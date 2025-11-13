// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final authProvider = Provider<AuthRepository>((ref) => AuthRepository());

// class AuthRepository {
//   final _client = Supabase.instance.client;

//   Future<Map<String, dynamic>> login({
//     required String role,
//     required String idOrEmail,
//     required String password,
//   }) async {
//     try {
//       if (role == 'mr') {
//         // For MR: match employee_id and password
//         final response = await _client
//             .from('mrs')
//             .select()
//             .eq('employee_id', idOrEmail)
//             .eq('password', password)
//             .maybeSingle();

//         if (response == null) {
//           throw Exception('Invalid credentials');
//         }

//         return {'success': true, 'data': response};
//       } else {
//         // For Doctor: match email and password
//         final response = await _client
//             .from('doctors')
//             .select()
//             .eq('email', idOrEmail)
//             .eq('password', password)
//             .maybeSingle();

//         if (response == null) {
//           throw Exception('Invalid credentials');
//         }

//         return {'success': true, 'data': response};
//       }
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/features/select_contacts/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(SelectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});

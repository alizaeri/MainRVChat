import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/features/select_contacts/controller/select_contact_controller.dart';
import 'package:rvchat/widgets/error.dart';

class SelectContactsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactContollerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  ConsumerState<SelectContactsScreen> createState() =>
      _SelectContactsScreenState();
}

class _SelectContactsScreenState extends ConsumerState<SelectContactsScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> allList = [];
  String searchContact = '';
  bool searchToggle = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onSearchChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChange);
    _controller.dispose();
    super.dispose();
  }

  _onSearchChange() {
    // ignore: avoid_print
    print(_controller.text);
    setState(() {
      searchContact = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6c5dd2),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: pinkL1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Image(
            image: Svg('assets/svg/back.svg'),
            fit: BoxFit.cover,
            color: white,
            width: 18,
          ),
        ),
        title: Row(
          children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              "RVC Select Contact",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "yknir",
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchToggle = !searchToggle;
              });
            },
            icon: Image(
              image: Svg('assets/svg/search.svg'),
              //fit: BoxFit.cover,
              color: white,
              width: 20,
              height: 20,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.redAccent,
                      primaryColorDark: Colors.red,
                    ),
                    child: searchToggle
                        ? TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search Contact',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                            // onChanged: filterContact,
                          )
                        : Container(),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: whiteW1),
                    child: ListView.builder(
                        itemCount: contactList.length,
                        itemBuilder: (context, index) {
                          if (searchContact.isEmpty) {
                            final contact = contactList[index];
                            return InkWell(
                              onTap: () =>
                                  widget.selectContact(ref, contact, context),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    contact.displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (contactList[index]
                              .displayName
                              .toLowerCase()
                              .contains(searchContact.toLowerCase())) {
                            final contact = contactList[index];
                            return InkWell(
                              onTap: () =>
                                  widget.selectContact(ref, contact, context),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    contact.displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ),
              ],
            ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

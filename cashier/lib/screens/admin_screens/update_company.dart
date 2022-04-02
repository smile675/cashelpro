import 'package:cashier/Widgets/admin_drawer.dart';
import 'package:cashier/models/company_model.dart';
import 'package:cashier/resourses/firestore_update_delete_method.dart';
import 'package:cashier/screens/common_screens/home.dart';
import 'package:cashier/utils/utils.dart';
import 'package:flutter/material.dart';

class UpdateCompanyProfile extends StatefulWidget {
  final Company company;
  const UpdateCompanyProfile({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  State<UpdateCompanyProfile> createState() => _UpdateCompanyProfileState();
}

class _UpdateCompanyProfileState extends State<UpdateCompanyProfile> {
  TextEditingController _newName = TextEditingController();
  TextEditingController _newPhone = TextEditingController();
  TextEditingController _newCurrencyCode = TextEditingController();
  TextEditingController _newHqLocation = TextEditingController();
  TextEditingController _newfullAddress = TextEditingController();

  bool _nameUpdated = false;
  bool _phoneUpdated = false;
  bool _currencyUpdated = false;
  bool _hqCityUpdated = false;
  bool _addressUpdated = false;

  @override
  void dispose() {
    _newName.dispose();
    _newPhone.dispose();
    _newCurrencyCode.dispose();
    _newHqLocation.dispose();
    _newfullAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _companyId = widget.company.uid;
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Update Company Profile'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text('Caution!'),
                      subtitle: Text(
                          'Be very Careful while updating <Company Profile\\>. However, you can update the fields individually. Therefore, update any field you need and then refresh the app so that it can be updated in all other places within the app and <database\\>.\n Thank You!'),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _newName,
                                decoration: InputDecoration(
                                    hintText: widget.company.companyName,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.teal),
                                    ),

                                    // filled: true,
                                    // fillColor: Colors.teal.withOpacity(0.3),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.business_center,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Update Name'),
                                      ],
                                    )),
                              ),
                            ),
                            _nameUpdated
                                ? const Icon(
                                    Icons.done_rounded,
                                    color: Colors.teal,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      if (_newName.text.isNotEmpty) {
                                        FireStoreUpdateDeleteMethods()
                                            .updateCompanyName(
                                                _companyId, _newName.text);
                                        setState(() {
                                          _nameUpdated = true;
                                        });
                                      } else {
                                        showSnackBar('Invalid Input', context);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.update,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // update phone

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                controller: _newPhone,
                                decoration: InputDecoration(
                                    hintText: widget.company.phoneNumber,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.teal),
                                    ),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Update Phone'),
                                      ],
                                    )),
                              ),
                            ),
                            _phoneUpdated
                                ? const Icon(
                                    Icons.done_rounded,
                                    color: Colors.teal,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      if (_newPhone.text.isNotEmpty) {
                                        FireStoreUpdateDeleteMethods()
                                            .updateCompanyPhone(
                                                _companyId, _newPhone.text);
                                        setState(() {
                                          _phoneUpdated = true;
                                        });
                                      } else {
                                        showSnackBar('Invalid Input', context);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.update,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    // update hq location city
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _newHqLocation,
                                decoration: InputDecoration(
                                    hintText: widget.company.hqLocation,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.teal),
                                    ),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.location_city,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Update HQ city'),
                                      ],
                                    )),
                              ),
                            ),
                            _hqCityUpdated
                                ? const Icon(
                                    Icons.done_rounded,
                                    color: Colors.teal,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      if (_newHqLocation.text.isNotEmpty) {
                                        FireStoreUpdateDeleteMethods()
                                            .updateCompanyHQcity(_companyId,
                                                _newHqLocation.text);
                                        setState(() {
                                          _hqCityUpdated = true;
                                        });
                                      } else {
                                        showSnackBar('Invalid Input', context);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.update,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                maxLength: 3,
                                controller: _newCurrencyCode,
                                decoration: InputDecoration(
                                    hintText: widget.company.currencyCode,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.teal),
                                    ),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.currency_exchange,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Update Currency Code'),
                                      ],
                                    )),
                              ),
                            ),
                            _currencyUpdated
                                ? const Icon(
                                    Icons.done_rounded,
                                    color: Colors.teal,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      if (_newCurrencyCode.text.isNotEmpty) {
                                        FireStoreUpdateDeleteMethods()
                                            .updateCompanyCurrencyCode(
                                                _companyId,
                                                _newCurrencyCode.text);
                                        setState(() {
                                          _currencyUpdated = true;
                                        });
                                      } else {
                                        showSnackBar('Invalid Input', context);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.update,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: 3,
                                controller: _newfullAddress,
                                decoration: InputDecoration(
                                    hintText: widget.company.fullAddress,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.teal),
                                    ),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.map_outlined,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Update Address'),
                                      ],
                                    )),
                              ),
                            ),
                            _addressUpdated
                                ? const Icon(
                                    Icons.done_rounded,
                                    color: Colors.teal,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      if (_newfullAddress.text.isNotEmpty) {
                                        FireStoreUpdateDeleteMethods()
                                            .updateCompanyFullAddress(
                                                _companyId,
                                                _newfullAddress.text);
                                        setState(() {
                                          _addressUpdated = true;
                                        });
                                      } else {
                                        showSnackBar('Invalid Input', context);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.update,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.teal,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Refresh App',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:photon/components/snackbar.dart';
import 'package:photon/methods/methods.dart';
import 'package:photon/models/share_history_model.dart';

import 'package:photon/services/photon_sender.dart';
import 'package:photon/views/apps_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../methods/handle_share.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({Key? key}) : super(key: key);

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  PhotonSender photonSePhotonSender = PhotonSender();
  bool isLoading = false;
  Box box = Hive.box('appData');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ValueListenableBuilder(
        valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
        builder: (_, AdaptiveThemeMode mode, __) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (!isLoading) ...{
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.asset(
                              box.get('avatarPath'),
                              height: 90,
                            ),
                            title: Text(
                              box.get('username'),
                              style: const TextStyle(
                                  fontFamily: "Aerial",
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            subtitle: Text(
                              'Fly#2394',
                              style: TextStyle(
                                  fontFamily: "Aerial",
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                HandleShare(context: context).onQrScanTap();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[300]),
                                width: 40,
                                child: const Icon(Icons.qr_code),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () async {
                                      if (Platform.isAndroid) {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                height: 200,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      minWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      color: mode.isDark
                                                          ? const Color
                                                                  .fromARGB(205,
                                                              117, 255, 122)
                                                          : Colors.blue,
                                                      onPressed: () async {
                                                        setState(() {
                                                          isLoading = true;
                                                        });

                                                        await PhotonSender
                                                            .handleSharing();

                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      },
                                                      child: const Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons.file_open,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'Files',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      minWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      color: mode.isDark
                                                          ? const Color
                                                                  .fromARGB(205,
                                                              117, 255, 122)
                                                          : Colors.blue,
                                                      onPressed: () async {
                                                        if (box.get(
                                                            'queryPackages')) {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const AppsList()));
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Query installed packages'),
                                                                content: const Text(
                                                                    'To get installed apps, you need to allow photon to query all installed packages. Would you like to continue ?'),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: const Text(
                                                                        'Go back'),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      box.put(
                                                                          'queryPackages',
                                                                          true);

                                                                      Navigator.of(
                                                                              context)
                                                                          .popAndPushNamed(
                                                                              '/apps');
                                                                    },
                                                                    child: const Text(
                                                                        'Continue'),
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/icons/android.svg',
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Text(
                                                            'Apps',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 50,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      } else {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        await PhotonSender.handleSharing();
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff5C3AFF),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.send_sharp,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Send File",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      if (Platform.isAndroid ||
                                          Platform.isIOS) {
                                        HandleShare(context: context)
                                            .onNormalScanTap();
                                      } else {
                                        Navigator.of(context)
                                            .pushNamed('/receivepage');
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff25C7C9),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.receipt,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Receive File",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(
                              Icons.search_outlined,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          columnwidget2(
                              "Flydrop Web", "Easiest Way to Transfer Files"),
                          const Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 1150,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 20, bottom: 5),
                            child: Row(
                              children: [
                                Text(
                                  "Favourite Friends",
                                  style: TextStyle(
                                      fontFamily: "Aerial",
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: index == 0 ? 20 : 4, right: 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[300] as Color),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQzWpKPrlIdn-PSLHytGVKG-h_V2fXDSZSjw&usqp=CAU'),
                                          ),
                                          Text(
                                            "Ashley",
                                            style: TextStyle(
                                                fontFamily: "Aerial",
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 20, bottom: 5, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Received",
                                  style: TextStyle(
                                      fontFamily: "Aerial",
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                Text(
                                  "See All",
                                  style: TextStyle(
                                      fontFamily: "Aerial",
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: FutureBuilder(
                              future: getHistory(),
                              builder: (context, AsyncSnapshot snap) {
                                if (snap.connectionState ==
                                    ConnectionState.done) {
                                  late List<ShareHistory> data;

                                  snap.data == null
                                      ? data = []
                                      : data = HistoryList.formData(snap.data)
                                          .historyList;

                                  return snap.data == null
                                      ? const Center(
                                          child: Text(
                                            'No Received File ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 70 *
                                              double.parse(
                                                  data.length.toString()),
                                          child: ListView.builder(
                                              padding: const EdgeInsets.all(0),
                                              itemCount: 5,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          top: 10),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      String path = data[index]
                                                          .filePath
                                                          .replaceAll(
                                                              r"\", "/");
                                                      if (Platform.isAndroid ||
                                                          Platform.isIOS) {
                                                        try {
                                                          OpenFile.open(path);
                                                        } catch (_) {
                                                          // ignore: use_build_context_synchronously
                                                          showSnackBar(context,
                                                              'No corresponding app found');
                                                        }
                                                      } else {
                                                        try {
                                                          launchUrl(
                                                            Uri.file(
                                                              path,
                                                              windows: Platform
                                                                  .isWindows,
                                                            ),
                                                          );
                                                        } catch (e) {
                                                          // ignore: use_build_context_synchronously
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Unable to open the file')));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                              color: Colors
                                                                      .grey[300]
                                                                  as Color)),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          getFileIcon(
                                                              data[index]
                                                                  .fileName
                                                                  .split('.')
                                                                  .last),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          columnwidget2(
                                                              data[index]
                                                                  .fileName,
                                                              getDateString(
                                                                  data[index]
                                                                      .date)),
                                                          const Expanded(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 20, bottom: 5, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Send",
                                  style: TextStyle(
                                      fontFamily: "Aerial",
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                Text(
                                  "See All",
                                  style: TextStyle(
                                      fontFamily: "Aerial",
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: FutureBuilder(
                              future: getSentFileHistory(),
                              builder: (context, AsyncSnapshot snap) {
                                if (snap.connectionState ==
                                    ConnectionState.done) {
                                  late List<ShareHistory> data;

                                  snap.data == null
                                      ? data = []
                                      : data = HistoryList.formData(snap.data)
                                          .historyList;

                                  return snap.data == null
                                      ? const Center(
                                          child: Text(
                                            'No Sent File',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 70 *
                                              double.parse(
                                                  data.length.toString()),
                                          child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.all(0),
                                              itemCount: 5,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          top: 10),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      String path = data[index]
                                                          .filePath
                                                          .replaceAll(
                                                              r"\", "/");
                                                      if (Platform.isAndroid ||
                                                          Platform.isIOS) {
                                                        try {
                                                          OpenFile.open(path);
                                                        } catch (_) {
                                                          // ignore: use_build_context_synchronously
                                                          showSnackBar(context,
                                                              'No corresponding app found');
                                                        }
                                                      } else {
                                                        try {
                                                          launchUrl(
                                                            Uri.file(
                                                              path,
                                                              windows: Platform
                                                                  .isWindows,
                                                            ),
                                                          );
                                                        } catch (e) {
                                                          // ignore: use_build_context_synchronously
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Unable to open the file')));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                              color: Colors
                                                                      .grey[300]
                                                                  as Color)),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          getFileIcon(
                                                              data[index]
                                                                  .fileName
                                                                  .split('.')
                                                                  .last),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          columnwidget2(
                                                              data[index]
                                                                  .fileName,
                                                              getDateString(
                                                                  data[index]
                                                                      .date)),
                                                          const Expanded(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                } else ...{
                  Center(
                    child: SizedBox(
                      width: size.width / 4,
                      height: size.height / 4,
                      child: Lottie.asset(
                        'assets/lottie/setting_up.json',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Please wait, file(s) are being fetched',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                },
              ],
            ),
          );
        });
  }
}

columnwidget2(title, value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontFamily: "Aerial",
                fontStyle: FontStyle.italic,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            value,
            style: const TextStyle(
                fontFamily: "Aerial",
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
        ],
      )
    ],
  );
}

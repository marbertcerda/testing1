///
///
/// !------------------------------------------------------------- PACKAGES
///
///
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:flex_color_scheme/flex_color_scheme.dart';
export 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

///
///
/// !------------------------------------------------------------- VIEWS
///
///
export 'package:testing/views/auth.wrapper.dart';

// * ---------------------- Commons
export 'package:testing/views/common/mydrawer.widget.dart';

// * ---------------------- Auth
export 'package:testing/views/auth/login.view.dart';
export 'package:testing/views/auth/register.view.dart';
export 'package:testing/views/auth/add_name.view.dart';

// * ---------------------- Home
export 'package:testing/views/home/home.view.dart';
export 'package:testing/views/home/widgets/notes_listview.widget.dart';
export 'package:testing/views/home/widgets/note_tile.widget.dart';

// * ---------------------- Settings
export 'package:testing/views/settings/settings.view.dart';

// * ---------------------- Notes
export 'package:testing/views/notes/create.view.dart';
export 'package:testing/views/notes/widgets/note_form_fields.dart';
export 'package:testing/views/notes/widgets/save_button.widget.dart';

///
///
/// !------------------------------------------------------------- MODEL
///
///
export 'package:testing/model/note.model.dart';
export 'package:testing/model/attachment.model.dart';

///
///
/// !------------------------------------------------------------- CONFIGURATION
///
///
export 'package:testing/config/theme.dart';

// * ---------------------- Enums
export 'package:testing/config/enums/note_colors.enum.dart';
export 'package:testing/config/enums/note_mode.enum.dart';

// * ---------------------- Constants
export 'package:testing/config/constants/note_colors.dart';

///
///
/// !------------------------------------------------------------- UTILS
///
///
export 'package:testing/utils/navigator.dart';

///
///
/// !------------------------------------------------------------- SERVICES
///
///
export 'package:testing/services/auth.service.dart';

///
///
/// !------------------------------------------------------------- DATABASE
///
///
export 'package:testing/database/notes.database.dart';

///
///
/// !------------------------------------------------------------- RIVERPOD
///
///
export 'package:testing/riverpod/theme.riverpod.dart';
export 'package:testing/riverpod/auth.riverpod.dart';
export 'package:testing/riverpod/notes.riverpod.dart';

import 'package:lecturers_appointment/core/views/custom_input.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/lecturer_provider.dart';
import 'lecturer_card.dart';

class LecturerSection extends ConsumerStatefulWidget {
  const LecturerSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LecturerSectionState();
}

class _LecturerSectionState extends ConsumerState<LecturerSection> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var lecturerStream = ref.watch(lecturersStreamProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if ((styles.smallerThanTablet &&
                      !ref.watch(isSearchingProvider)) ||
                  !styles.smallerThanTablet)
                Text(
                  'Our Lecturers',
                  style: styles.title(
                      color: primaryColor, desktop: 26, tablet: 22, mobile: 18),
                ),
              const Spacer(),
              if ((styles.smallerThanTablet &&
                      ref.watch(isSearchingProvider)) ||
                  !styles.smallerThanTablet)
                SizedBox(
                    width: styles.isMobile
                        ? 300
                        : styles.isTablet
                            ? 450
                            : 500,
                    child: CustomTextFields(
                      hintText: 'Search Lecturers',
                      onChanged: (value) {
                        ref
                            .read(lecturersFilterProvider.notifier)
                            .filterLecturers(value);
                      },
                    )),
              const SizedBox(width: 10),
              if (styles.smallerThanTablet)
                IconButton(
                  style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      backgroundColor: WidgetStateProperty.all(primaryColor)),
                  onPressed: () {
                    ref.read(isSearchingProvider.notifier).state =
                        !ref.watch(isSearchingProvider);
                  },
                  icon: Icon(ref.watch(isSearchingProvider)
                      ? Icons.cancel
                      : Icons.search),
                ),
            ],
          ),
          const SizedBox(height: 20),
          lecturerStream.when(data: (data) {
            var data = ref.watch(lecturersFilterProvider);
            if (data.filter.isEmpty) {
              return const SizedBox(
                  height: 200,
                  child: Center(child: Text('No lecturer found ')));
            }
            return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: data.filter.map((lecturer) {
                  return LecturerCard(lecturer);
                }).toList());
          }, error: (error, stack) {
            return SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(child: Text(error.toString())));
          }, loading: () {
            return const SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ));
          })
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/data.dart';
import 'package:to_do/main.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.task.name,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.task.name = _controller.text;
          widget.task.priority = widget.task.priority;
          if (widget.task.isInBox) {
            widget.task.save();
          } else {
            final Box<Task> box = Hive.box(taskBoxName);
            box.add(widget.task);
          }

          Navigator.of(context).pop();
        },
        label: Row(
          children: const [
            Text('Save Changes'),
            SizedBox(width: 2),
            Icon(Icons.check, size: 18),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.high;
                      });
                    },
                    label: 'High',
                    color: highPriority,
                    isSelected: widget.task.priority == Priority.high,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.normal;
                      });
                    },
                    label: 'Normal',
                    color: normalPriority,
                    isSelected: widget.task.priority == Priority.normal,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.low;
                      });
                    },
                    label: 'Low',
                    color: Color(0xff3BE1F1),
                    isSelected: widget.task.priority == Priority.low,
                  ),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                label: Text(
                  'Add a task for today ...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withValues(alpha: 0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(child: Text(label)),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: CheckBoxShape(value: isSelected, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const CheckBoxShape({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child:
          value
              ? Icon(
                CupertinoIcons.check_mark,
                size: 12,
                color: themeData.colorScheme.onPrimary,
              )
              : null,
    );
  }
}

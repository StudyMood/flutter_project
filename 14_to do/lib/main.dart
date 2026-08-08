import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diploma IT To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007BFF),
          brightness: Brightness.light,
        ),
      ),
      home: const TodoHomeScreen(),
    );
  }
}

class TaskItem {
  String text;
  bool isCompleted;

  TaskItem({required this.text, this.isCompleted = false});
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final TextEditingController _taskController = TextEditingController();

  // Active tasks pre-populated as in index.html
  final List<TaskItem> _tasks = [
    TaskItem(text: 'Complete DBMS Assignment', isCompleted: false),
    TaskItem(text: 'Revise C Programming', isCompleted: true),
    TaskItem(text: 'Prepare for Java Lab Test', isCompleted: false),
  ];

  // Deleted tasks bin
  final List<String> _deletedTasks = [];

  // Toggle deleted section view
  bool _showDeletedSection = false;

  void _addNewTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Please write something!'),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _tasks.add(TaskItem(text: text));
      _taskController.clear();
    });
  }

  void _updateTask(int index) {
    final editController = TextEditingController(text: _tasks[index].text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Update Task'),
          content: TextField(
            controller: editController,
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Task title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF198754),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final updatedText = editController.text.trim();
                if (updatedText.isNotEmpty) {
                  setState(() {
                    _tasks[index].text = updatedText;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    final removed = _tasks[index];
    setState(() {
      _deletedTasks.add(removed.text);
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved "${removed.text}" to deleted tasks.'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _deletedTasks.removeLast();
              _tasks.insert(index, removed);
            });
          },
        ),
      ),
    );
  }

  void _restoreTask(int index) {
    final restoredText = _deletedTasks[index];
    setState(() {
      _deletedTasks.removeAt(index);
      _tasks.add(TaskItem(text: restoredText));
    });
  }

  void _permanentlyDeleteTask(int index) {
    setState(() {
      _deletedTasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF89F7FE), Color(0xFF66A6FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Title
                        const Text(
                          '📚 Diploma IT Student To-Do List',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212529),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Add Task Input Row
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _taskController,
                                onSubmitted: (_) => _addNewTask(),
                                decoration: InputDecoration(
                                  hintText: 'Add new task...',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D6EFD),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _addNewTask,
                              child: const Text(
                                'Add',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Task List
                        if (_tasks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              '🎉 No pending tasks! Enjoy your day.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _tasks.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: task.isCompleted
                                      ? const Color(0xFFEAF0FF)
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: task.isCompleted
                                        ? const Color(0xFFB0C4DE)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final isMobile = constraints.maxWidth < 420;

                                    final bullet = Container(
                                      width: 24,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${String.fromCharCode(65 + (index % 26))}.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    );

                                    final checkbox = Checkbox(
                                      value: task.isCompleted,
                                      activeColor: Colors.grey.shade600,
                                      onChanged: (val) {
                                        setState(() {
                                          task.isCompleted = val ?? false;
                                        });
                                      },
                                    );

                                    final taskTextWidget = GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          task.isCompleted = !task.isCompleted;
                                        });
                                      },
                                      child: Text(
                                        task.text,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          decoration: task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: task.isCompleted
                                              ? Colors.grey.shade600
                                              : Colors.black87,
                                        ),
                                      ),
                                    );

                                    final updateBtn = ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF198754,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => _updateTask(index),
                                      child: const Text(
                                        'Update',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    );

                                    final deleteBtn = ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFDC3545,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => _deleteTask(index),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    );

                                    if (isMobile) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              bullet,
                                              checkbox,
                                              Expanded(child: taskTextWidget),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              updateBtn,
                                              const SizedBox(width: 8),
                                              deleteBtn,
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          bullet,
                                          checkbox,
                                          Expanded(child: taskTextWidget),
                                          const SizedBox(width: 8),
                                          updateBtn,
                                          const SizedBox(width: 6),
                                          deleteBtn,
                                        ],
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),

                        const SizedBox(height: 24),

                        // Toggle Deleted Tasks Section Button
                        Center(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF212529),
                              side: const BorderSide(color: Color(0xFF212529)),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _showDeletedSection = !_showDeletedSection;
                              });
                            },
                            icon: const Text(
                              '🗑',
                              style: TextStyle(fontSize: 16),
                            ),
                            label: Text(
                              _showDeletedSection
                                  ? 'Hide Deleted Tasks'
                                  : 'Show Deleted Tasks (${_deletedTasks.length})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // Deleted Tasks Section
                        if (_showDeletedSection) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '🗑 Deleted Tasks',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              if (_deletedTasks.isNotEmpty)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _deletedTasks.clear();
                                    });
                                  },
                                  child: const Text(
                                    'Clear All',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_deletedTasks.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'No deleted tasks.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _deletedTasks.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _deletedTasks[index],
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.restore,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        tooltip: 'Restore',
                                        onPressed: () => _restoreTask(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        tooltip: 'Delete Permanently',
                                        onPressed: () =>
                                            _permanentlyDeleteTask(index),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/book.dart';

class EditBookScreen extends StatefulWidget {
  final Book? book;

  EditBookScreen({this.book});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late int _rating;
  bool _isRead = false; // Added field for isRead

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _title = widget.book!.title;
      _author = widget.book!.author;
      _rating = widget.book!.rating;
      _isRead = widget.book!.isRead; // Initialize isRead
    } else {
      _title = '';
      _author = '';
      _rating = 0;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final book = Book(
        id: widget.book?.id,
        title: _title,
        author: _author,
        rating: _rating,
        isRead: _isRead, // Include isRead in the book object
      );
      Navigator.of(context).pop(book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Background color
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book == null ? 'Add a New Book' : 'Edit Book Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple, // Title color
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  onSaved: (value) => _title = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _author,
                  decoration: InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  onSaved: (value) => _author = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter an author' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _rating.toString(),
                  decoration: InputDecoration(
                    labelText: 'Rating',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.star),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _rating = int.parse(value!),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a rating';
                    }
                    final rating = int.tryParse(value);
                    if (rating == null || rating < 0 || rating > 5) {
                      return 'Please enter a rating between 0 and 5';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Read:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(width: 8),
                    Switch(
                      value: _isRead,
                      onChanged: (value) {
                        setState(() {
                          _isRead = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // Button color
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

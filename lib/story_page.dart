import 'dart:async';
import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  final String user;
  final List<String> stories;
  final List<Map<String, dynamic>> usersStories;
  final int currentUserIndex;

  StoryPage({
    required this.user,
    required this.stories,
    required this.usersStories,
    required this.currentUserIndex,
  });

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _animationController;
  Timer? _progressTimer;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (_currentPage < widget.stories.length - 1) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else {
            _showNextUserStories();
          }
        }
      });
    _startAnimation();
  }

  void _startAnimation() {
    _animationController.forward();
    _startProgressTimer();
  }

  void _resetAnimation() {
    _animationController.stop();
    _animationController.reset();
    _stopProgressTimer();
    setState(() {
      _progressValue = 0.0;
    });
  }

  void _startProgressTimer() {
    _stopProgressTimer();
    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _progressValue += 0.02;
        if (_progressValue >= 1.0) {
          _progressValue = 1.0;
          timer.cancel();
        }
      });
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
  }

  void _showNextUserStories() {
    if (widget.currentUserIndex < widget.usersStories.length - 1) {
      final nextUserStory = widget.usersStories[widget.currentUserIndex + 1];
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => StoryPage(
            user: nextUserStory['user'],
            stories: nextUserStory['stories'],
            usersStories: widget.usersStories,
            currentUserIndex: widget.currentUserIndex + 1,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fan-like transition effect
            return AnimatedBuilder(
              animation: animation,
              child: child,
              builder: (context, child) {
                final double rotateAngle = (1 - animation.value) * -0.5; // Control the angle of rotation
                final double translateX = MediaQuery.of(context).size.width * (1 - animation.value); // Control the horizontal movement
                final double translateY = MediaQuery.of(context).size.height * (1 - animation.value) * 0.5; // Control the vertical movement
                
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(translateX, translateY)
                    ..rotateZ(rotateAngle),
                  child: child,
                );
              },
            );
          },
        ),
      );
    } else {
      Navigator.of(context).pop(); // No more stories, return to home page
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _stopProgressTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          _resetAnimation();
          if (details.globalPosition.dx < MediaQuery.of(context).size.width / 2) {
            if (_currentPage > 0) {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
            }
          } else {
            if (_currentPage < widget.stories.length - 1) {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
            } else {
              _showNextUserStories();
            }
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _resetAnimation();
                _startAnimation();
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.stories[index],
                  fit: BoxFit.cover,
                );
              },
            ),
            Positioned(
              top: 50.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStoryProgressBar(),
                  SizedBox(height: 10),
                  Text(
                    widget.user,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryProgressBar() {
    return Row(
      children: List.generate(widget.stories.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: LinearProgressIndicator(
              value: _currentPage == index
                  ? _progressValue
                  : (_currentPage > index ? 1.0 : 0.0),
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StoryPage(
      user: "User 1",
      stories: [
        'https://via.placeholder.com/400x700.png?text=Story+1',
        'https://via.placeholder.com/400x700.png?text=Story+2',
      ],
      usersStories: [
        {
          'user': 'User 1',
          'stories': [
            'https://via.placeholder.com/400x700.png?text=Story+1',
            'https://via.placeholder.com/400x700.png?text=Story+2',
          ]
        },
        {
          'user': 'User 2',
          'stories': [
            'https://via.placeholder.com/400x700.png?text=Story+3',
            'https://via.placeholder.com/400x700.png?text=Story+4',
          ]
        },
      ],
      currentUserIndex: 0,
    ),
  ));
}

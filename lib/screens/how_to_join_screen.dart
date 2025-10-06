import 'package:flutter/material.dart';

class HowToJoinScreen extends StatelessWidget {
  const HowToJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Become a Volunteer'),
      ),
      body: Theme(
        // Overriding theme locally to make the stepper controls green
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.green,
              ),
        ),
        child: Stepper(
          // The stepper is horizontal by default, but vertical is better for long text
          // type: StepperType.horizontal,
          currentStep: 0, // You could make this dynamic if needed
          steps: const [
            Step(
              title: Text('Sign Up'),
              content: Text('Register your name and contact details with our organization to get started.'),
              isActive: true,
            ),
            Step(
              title: Text('Pick an Event'),
              content: Text('Browse through our list of opportunities and choose one that you feel passionate about.'),
              isActive: true,
            ),
            Step(
              title: Text('Arrive On Time'),
              content: Text('Punctuality is key. Please arrive at the specified location at least 15 minutes early.'),
              isActive: true,
            ),
            Step(
              title: Text('Participate!'),
              content: Text('Engage with the community, follow the coordinator\'s lead, and make a real difference!'),
              isActive: true,
            ),
          ],
          // Remove the default buttons as this is for display only
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
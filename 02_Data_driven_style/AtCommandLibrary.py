import serial
import re

class AtCommandLibrary(object):
    ''' Library for interacting with a simple device using AT commands '''
    #ROBOT_LIBRARY_SCOPE = 'SUITE'
    
    def __init__(self):
        # Initialize the serial port connection with the correct port and baud rate
        self.serial = serial.Serial('/dev/tty.usbmodem1101', 9600, timeout=1)

    def send_text(self, text):
        # Convert input text to uppercase and replace special characters with 'X',
        # but allow + to remain in the text for valid AT commands
        text = re.sub(r'[^A-Z0-9\s+]', 'X', text.upper())
        # Clear the input buffer before sending the command
        self.serial.reset_input_buffer()
        # Send the AT command over the serial connection
        self.serial.write(bytes('AT+SEND="' + text + '"\n', 'iso-8859-1'))

    def response_should_be(self, expected_text):
        # Read the response from the device
        text = self.serial.readline().strip().decode('iso-8859-1')
        
        # Normalize whitespace in both expected and actual responses
        normalized_text = ' '.join(text.split())
        normalized_expected = ' '.join(expected_text.split())
        
        # Check if the normalized response matches the normalized expected text
        if normalized_text != normalized_expected:
            raise AssertionError(f"Expected: '{expected_text}' got: '{text}'")

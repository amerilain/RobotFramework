import serial
import re

class AtCommandLibrary:
    '''Library for interacting with a simple device using AT commands'''

    ROBOT_LIBRARY_SCOPE = 'SUITE'
    
    def __init__(self, port='/dev/tty.usbmodem1101'):
        self._port = serial.Serial(port, 115200, timeout=1)

    def send_text(self, text):
        '''Sends text to the device and waits for a response.'''
        self._port.reset_input_buffer()
        print(f"Sending: AT+SEND=\"{text}\"")  # Debug output
        self._port.write(bytes('AT+SEND="' + text + '"\n', 'iso-8859-1'))
        
        response = self._port.readline().strip().decode('iso-8859-1')
        print(f"Received response: {response}")  # Debug output
        return response

    def response_should_be(self, expected_text):
        """Checks if the response from the device matches the expected text or a valid 'SENT' response."""
        response = self._port.readline().strip().decode('iso-8859-1')
        valid_sent_pattern = f'SENT="{expected_text}"'
        
        if response != expected_text and response != "OK" and response != valid_sent_pattern:
            raise AssertionError(f'Expected: "{expected_text}", "OK", or "{valid_sent_pattern}", got: "{response}"')
    
    def set_echo(self, status):
        '''Sets the echo status on the device and verifies the response.'''
        command = 'ATE1' if status.upper() == 'ON' else 'ATE0'
        self._port.write(bytes(command + '\n', 'iso-8859-1'))
        response = self._port.readline().strip().decode('iso-8859-1')
        print(f"Echo set command response: {response}")  # Debug output

        if response not in ["OK", "ATE1", "ATE0"]:
            raise AssertionError(f"Failed to set echo to {status}. Response: {response}")
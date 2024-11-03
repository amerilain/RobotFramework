import serial

class AtCommandLibrary(object):
    ''' Library for interacting with a simple device using AT commands '''
    ROBOT_LIBRARY_SCOPE = 'SUITE'
    
    def __init__(self, port='/dev/cu.usbmodem1101'):
        # Use a default port if none is specified
        self._port = serial.Serial(port, 115200, timeout=1)

    def send_text(self, text):
        self._port.reset_input_buffer()
        self._port.write(bytes('AT+SEND="' + text + '"\n', 'iso-8859-1'))

    def response_should_be(self, expected_text):
        text = self._port.readline().strip().decode('iso-8859-1')
        if text != expected_text:
            raise AssertionError(f'Expected: "{expected_text}" got: "{text}"')

    def set_echo(self, status):
        command = 'ATE1' if status.upper() == 'ON' else 'ATE0'
        self._port.write(bytes(command + '\n', 'iso-8859-1'))
        response = self._port.readline().strip().decode('iso-8859-1')
        if response != "OK":
            raise AssertionError(f"Failed to set echo to {status}. Response: {response}")

    def check_echo_status(self, expected_status):
        self._port.write(bytes('ATE?\n', 'iso-8859-1'))
        response = self._port.readline().strip().decode('iso-8859-1')
        expected_response = '1' if expected_status.upper() == 'ON' else '0'
        if response != expected_response:
            raise AssertionError(f"Expected echo status '{expected_status}', but got '{response}'")
import unittest
import socket

from app import app


class FlaskAppTests(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_healthcheck(self):
        # GIVEN
        ip = socket.gethostbyname(socket.gethostname())

        # WHEN
        response = self.app.get('/')
        data = response.get_json()

        # THEN
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['healthcheck'], 'ok')
        self.assertEqual(data['internal_ip'], ip)

    def test_host_ip(self):
        # GIVEN
        ip = socket.gethostbyname(socket.gethostname())

        # WHEN
        response = self.app.get('/host')
        data = response.get_json()

        # THEN
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['internal_ip'], ip)


if __name__ == '__main__':
    unittest.main()

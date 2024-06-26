import unittest
import os

from app import app


class FlaskAppTests(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_healthcheck(self):
        # GIVEN
        hostname = os.uname()[1]

        # WHEN
        response = self.app.get("/")
        data = response.get_json()

        # THEN
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data["healthcheck"], "ok")
        self.assertEqual(data["hostname"], hostname)

    def test_host_ip(self):
        # GIVEN
        ip = os.uname()[1]

        # WHEN
        response = self.app.get("/host")
        data = response.get_json()

        # THEN
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data["hostname"], ip)

    # def test_fail(self):
    #     self.assertEqual(True, False)


if __name__ == "__main__":
    unittest.main()

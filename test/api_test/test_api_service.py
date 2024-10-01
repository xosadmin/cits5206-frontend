import unittest
import requests

class ApiServiceTest(unittest.TestCase):

    base_url = "https://cits5206.7m7.moe"

    # Test login functionality
    def test_login_user(self):
        url = f'{self.base_url}/login'
        payload = {
            'username': 'testuser',
            'password': 'testpassword'
        }
        response = requests.post(url, data=payload)

        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertTrue(data['Status'], "Sign in should be successful")
        self.assertIn('Token', data, "Response should contain token")

    # Test registration functionality
    def test_register_user(self):
        url = f'{self.base_url}/register'
        payload = {
            'username': 'newuser',
            'password': 'newpassword'
        }
        response = requests.post(url, data=payload)

        self.assertIn(response.status_code, [200, 201])
        data = response.json()
        self.assertTrue(data['Status'], "Registration should be successful")
        self.assertIn('userID', data, "Response should contain userID")

    # Test change password functionality
    def test_change_password(self):
        token = 'your_token_here'
        url = f'{self.base_url}/changepass'
        payload = {
            'password': 'newpassword'
        }
        headers = {
            'Authorization': f'Bearer {token}'
        }
        response = requests.post(url, data=payload, headers=headers)

        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertTrue(data['Status'], "Password change should be successful")

    # Test update user information functionality
    def test_set_user_info(self):
        url = f'{self.base_url}/setuserinfo'
        payload = {
            'userID': '12345',
            'firstname': 'John',
            'lastname': 'Doe',
            'dob': '1990-01-01'
        }
        response = requests.post(url, data=payload)

        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertTrue(data['Status'], "User information should be updated")

    # Test update user interests functionality
    def test_set_user_interests(self):
        url = f'{self.base_url}/setuserinterest'
        payload = {
            'userID': '12345',
            'interests': 'coding,reading,gaming'
        }
        response = requests.post(url, data=payload)

        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertTrue(data['Status'], "User interests should be updated")

if __name__ == '__main__':
    unittest.main()
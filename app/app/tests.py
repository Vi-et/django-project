from django.test import SimpleTestCase

from app import calc

class CalcTest(SimpleTestCase):
    def test_add(self):
        self.assertEqual(calc.add(3, 8), 11)
        
    def test_subtract(self):
        self.assertEqual(calc.subtract(5, 11), 6)
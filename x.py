from num2words import num2words
import re
from os import remove

regex = re.compile(r'(and|,|-| )')
remove('src/numerals.rs')
with open('src/numerals.rs', 'a') as f:
    f.write("const one:i64 = i64::MAX / i64::MAX;\n")
    for i in range(2, 9223372036854775807):
        ultimate = num2words(i)
        ultimate = regex.sub(r'', ultimate)
        penultimate = num2words(i-1)
        penultimate = regex.sub(r'', penultimate)
        f.write(f"const {ultimate}:i64 = {penultimate}+one;\n")

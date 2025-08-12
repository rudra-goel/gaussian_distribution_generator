import math
import numpy as np # type: ignore
from datetime import datetime

def dec_to_twos_comp_binary(decimal_val):
    binary_string = ""
    if decimal_val == 1:
        binary_string = "00000000000000000000000000000001"
        return binary_string
    
    #determine sign of decimal value
    if decimal_val < 0:
        binary_string += "1"
    else:
        binary_string += "0"

    abs_val = abs(decimal_val)

    abs_val *= 2**31

    # print("abs_val is ", abs_val)

    if abs_val == 0:
        binary_string = "0" * 32
        return binary_string

    # Convert the integer part to binary
    while abs_val != 0:
        if abs_val % 2 == 0:
            binary_string = binary_string + "0"
        else:
            binary_string = binary_string + "1"

        abs_val = abs_val // 2

    while len(binary_string) < 32:
        binary_string +="0"

    return binary_string

def dec_to_twos_comp_binary_ln(decimal_val):
    binary_string = ""
    if decimal_val == 1:
        binary_string = "0" * 31 + "1"
        return binary_string

    abs_val = abs(decimal_val)

    if abs_val == 0:
        binary_string = "0" * 32
        return binary_string

    #grab the integer part
    int_part = int(abs_val)
    while int_part != 0:
        if int_part % 2 == 0:
            binary_string = binary_string + "0"
        else:
            binary_string = binary_string + "1"
        int_part = int_part // 2
    
    remaining_bits = 32 - len(binary_string)
    scale = 2 ** remaining_bits
    frac_part = abs_val - int(abs_val)
    frac_part = int(frac_part * scale)
    
    while frac_part != 0:
        if frac_part % 2 == 0:
            binary_string = binary_string + "0"
        else:
            binary_string = binary_string + "1"
        frac_part = frac_part // 2

    while len(binary_string) < 32:
        binary_string +="0"

    return binary_string

def generate_compact_trig_lut(func_name, func, filename, num_entries=2**16):
    print(f"\nGenerating compact {func_name} lookup table...")
    print(f"Entries: {num_entries:,}")
    
    try:
        with open(filename, 'w') as mif_file:            
            step = 2.0 * math.pi / num_entries
            
            for i in range(num_entries):
                angle = i * step
                value = func(angle)
                binary_value = dec_to_twos_comp_binary(value)

                # print("Angle is ", angle, "\tValue is", value, "\tBinary is", binary_value)
                mif_file.write(f"{binary_value}\n")

                if i % 10000 == 0:
                    progress = (i / num_entries) * 100
                    print(f"Progress: {progress:.1f}%")
    
    except Exception as e:
        print(f"Error generating compact {filename}: {e}")
        return False
    
    print(f"Compact {func_name} lookup table generated successfully!")
    return True

def generate_ln_lut(func_name, func, filename, num_entries=2**16):
    print(f"\nGenerating compact {func_name} lookup table...")
    print(f"Entries: {num_entries:,}")
    
    try:
        with open(filename, 'w') as mif_file:            
            
            for i in range(1, num_entries+1):

                value = func(i)
                binary_value = dec_to_twos_comp_binary_ln(value)

                print("Angle is ", i, "\tValue is", value, "\tBinary is", binary_value)
                mif_file.write(f"{binary_value}\n")

                if i % 10000 == 0:
                    progress = (i / num_entries) * 100
                    print(f"Progress: {progress:.1f}%")
    
    except Exception as e:
        print(f"Error generating compact {filename}: {e}")
        return False
    
    print(f"Compact {func_name} lookup table generated successfully!")
    return True

def main():
    """Main function to generate trigonometric lookup tables."""
    print("Trigonometric and LN LUT Generator")
    print("=" * 50)

    # generate_compact_trig_lut("COSINE", np.cos, "cosine_lut_16bit.mif", num_entries=2**16)
    # generate_compact_trig_lut("SINE", np.sin, "sine_lut_16bit.mif", num_entries=2**16)
    generate_ln_lut("NATURAL LOG", np.log, "ln_lut_16bit.mif", num_entries=2**16)

    print("\nGeneration complete!")

if __name__ == "__main__":
    main()

Design Hierarchy
<pre>
-------------------------------------------------------------
Hierarchy of tb_test_digital_side is:

tb_test_digital_side
    ├─ test_digital_side : test_digital_side 
        │   ├─ counter : x_counter 
        │   ├─ counter : y_counter
        │   ├─ xor18 : xy_invert_logic
        │   ├─ slow_counter : slow_counter
                │   ├─ pulse_generator : hz6_counter 
                │   ├─ pulse_generator : hz3_counter
                │   ├─ pulse_generator : hz1_5_counter
                │   ├─ pulse_generator : hz_6_counter
                │   ├─ pulse_generator : hz_4_counter
                │   ├─ pulse_generator : hz_2_counter
        │   ├─ nand4 : overlay_gates 
        │   ├─ invert_4 : inverters
        │   ├─ monstable_4 : edge
                │   ├─ edge_detector : ed_1 
                │   ├─ edge_detector : ed_2
                │   ├─ edge_detector : ed_3
                │   ├─ edge_detector : ed_4
        │   ├─ delay_800us : delay_800 
        │   ├─ d_flipflop_ext : flip_flop1
        │   ├─ d_flipflop_ext : flip_flop2
        │   ├─ compare_7 : comparitor
                │   ├─ window_comparator : wc_5 
                │   ├─ window_comparator : wc_4
                │   ├─ window_comparator : wc_3
                │   ├─ window_comparator : wc_2
                │   ├─ window_comparator : wc_1
                │   ├─ window_comparator : wc_0
                │   ├─ xor_n : xor_n
        │   ├─ xor_n : matrix_input_inverters 
        │   ├─ or_matrix_full : pin_matrix
                │   ├─ xpoint_or : or_mattrix 
        │   ├─ xor_n : luma_output 
        │   ├─ mux_5 : chroma_output
                │   ├─ mux2_1 : mux1 
                │   ├─ mux2_1 : mux2
                │   ├─ mux2_1 : mux3
                │   ├─ mux2_1 : mux4
                │   ├─ mux2_1 : mux5
                │   ├─ mux2_1 : mux6
    ├─ write_file_ex : write_file_ex 
-------------------------------------------------------------
</pre>
<pre>
-------------------------------------------------------------
Hierarchy of tb_analog_side is:

tb_analog_side
    ├─ analog_side : analog_side 
        │   ├─ adder_12bit_nooverflow : pos_h_1_mix 
        │   ├─ adder_12bit_nooverflow : pos_v_1_mix
        │   ├─ adder_12bit_nooverflow : zoom_h_1_mix
        │   ├─ adder_12bit_nooverflow : zoom_v_1_mix
        │   ├─ adder_12bit_nooverflow : circle_1_mix
        │   ├─ adder_12bit_nooverflow : gear_1_mix
        │   ├─ adder_12bit_nooverflow : lantern_1_mix
        │   ├─ adder_12bit_nooverflow : fizz_1_mix
        │   ├─ mixer_interface : analox_matrix
                │   ├─ analog_matrix : analog_matrix 
                        │   ├─ audiomixer : audiomixer 
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
                        │   ├─ audiomixer : audiomixer
        │   ├─ sinwavegenerator : osc1 
        │   ├─ sinwavegenerator : osc2
        │   ├─ random_voltage : random_1
                │   ├─ shift_sipo : sipo_1 
                │   ├─ shift_sipo : sipo_2
                │   ├─ mux_8_to_1 : mux_random
                │   ├─ counter : random_freq
                │   ├─ slew_wraper : slew_output_1
                        │   ├─ moving_average : slew_fast 
                        │   ├─ moving_average : slew_med
                        │   ├─ moving_average : slew_slow
                        │   ├─ moving_average : slew_snail
                │   ├─ slew_wraper : slew_output_2 
                        │   ├─ moving_average : slew_fast 
                        │   ├─ moving_average : slew_med
                        │   ├─ moving_average : slew_slow
                        │   ├─ moving_average : slew_snail
        │   ├─ adder_12bit_nooverflow : y_dig_ann_mix 
        │   ├─ adder_12bit_nooverflow : u_dig_ann_mix
        │   ├─ adder_12bit_nooverflow : v_dig_ann_mix
        │   ├─ yuv_levels : yuv_out_levels
                │   ├─ alphablend : alphablend 
                │   ├─ alphablend : alphablend
                │   ├─ alphablend : alphablend
-------------------------------------------------------------
</pre>

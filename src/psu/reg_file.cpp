// -- Auto Generated VHDL header file for register file
// -- 0x00   R    
// -- 0x04   R    matrix_out_addr_int(5:0)  
// -- 0x08   R    matrix_load_int(0:0)  
// -- 0x10   R    mask_lower(31:0)  
// -- 0x14   R    mask_upper(31:0)  
// -- 0x18   R    
// -- 0x1c   R    inv_lower(31:0)  
// -- 0x20   R    inv_upper(31:0)  
// -- 0x24   R    vid_span_int(7:0)  
// -- 0x28   R    out_addr_int(7:0)  
// -- 0x2c   R    ch_addr_int(7:0)  
// -- 0x30   R    gain_in_int(4:0)  
// -- 0x34   R    anna_matrix_wr_int(0:0)  
// -- 0x3c   R    pos_h_i_2(17:9)  pos_h_i_1(8:0)    
// -- 0x40   R    pos_v_i_2(17:9)  pos_v_i_1(8:0)    
// -- 0x44   R    zoom_h_i_2(17:9)  zoom_h_i_1(8:0)  
// -- 0x48   R    zoom_v_i_2(17:9)  zoom_v_i_1(8:0)
// -- 0x4c   R    circle_i_2(17:9)  circle_i_1(8:0)
// -- 0x50   R    gear_i_2(17:9)  gear_i_1(8:0)
// -- 0x54   R    lantern_i_2(17:9)  lantern_i_1(8:0)
// -- 0x5c   R    fizz_i_2(17:9)  fizz_i_1(8:0)
// -- 0x60   R    cycle_recycle_i(13:13)  slew_in_i(12:10)  noise_freq_i(9:0)
// -- 0x64   R    cr_level_i(23:12)  y_level_i(11:0)
// -- 0x68   R    cb_level_i(11:0)
// -- 0x6c   R    video_active(0:0)
// -- 0x70   R    sync_sel_osc1_i(21:20)  osc_1_derv_i(19:10)  osc_1_freq_i(9:0)
// -- 0x74   R    sync_sel_osc2_i(21:20)  osc_2_derv_i(19:10)  osc_2_freq_i(9:0)
// -- 0x80   R

// Auto Generated C/C++ header file for register file
#define matrix_out_addr_int     0x04
#define matrix_out_addr_int_shift     0
#define matrix_out_addr_int_size      6
#define matrix_load_int     0x08
#define matrix_load_int_shift     0
#define matrix_load_int_size      1
#define mask_lower     0x10
#define mask_lower_shift     0
#define mask_lower_size      32
#define mask_upper     0x14
#define mask_upper_shift     0
#define mask_upper_size      32
#define inv_lower     0x1c
#define inv_lower_shift     0
#define inv_lower_size      32
#define inv_upper     0x20
#define inv_upper_shift     0
#define inv_upper_size      32
#define vid_span_int     0x24
#define vid_span_int_shift     0
#define vid_span_int_size      8
#define out_addr_int     0x28
#define out_addr_int_shift     0
#define out_addr_int_size      8
#define ch_addr_int     0x2c
#define ch_addr_int_shift     0
#define ch_addr_int_size      8
#define gain_in_int     0x30
#define gain_in_int_shift     0
#define gain_in_int_size      5
#define anna_matrix_wr_int     0x34
#define anna_matrix_wr_int_shift     0
#define anna_matrix_wr_int_size      1
#define pos_h_i_1     0x3c
#define pos_h_i_1_shift     0
#define pos_h_i_1_size      9
#define pos_h_i_2     0x3c
#define pos_h_i_2_shift     9
#define pos_h_i_2_size      9
#define pos_v_i_1     0x40
#define pos_v_i_1_shift     0
#define pos_v_i_1_size      9
#define pos_v_i_2     0x40
#define pos_v_i_2_shift     9
#define pos_v_i_2_size      9
#define zoom_h_i_1     0x44
#define zoom_h_i_1_shift     0
#define zoom_h_i_1_size      9
#define zoom_h_i_2     0x44
#define zoom_h_i_2_shift     9
#define zoom_h_i_2_size      9
#define zoom_v_i_1     0x48
#define zoom_v_i_1_shift     0
#define zoom_v_i_1_size      9
#define zoom_v_i_2     0x48
#define zoom_v_i_2_shift     9
#define zoom_v_i_2_size      9
#define circle_i_1     0x4c
#define circle_i_1_shift     0
#define circle_i_1_size      9
#define circle_i_2     0x4c
#define circle_i_2_shift     9
#define circle_i_2_size      9
#define gear_i_1     0x50
#define gear_i_1_shift     0
#define gear_i_1_size      9
#define gear_i_2     0x50
#define gear_i_2_shift     9
#define gear_i_2_size      9
#define lantern_i_1     0x54
#define lantern_i_1_shift     0
#define lantern_i_1_size      9
#define lantern_i_2     0x54
#define lantern_i_2_shift     9
#define lantern_i_2_size      9
#define fizz_i_1     0x5c
#define fizz_i_1_shift     0
#define fizz_i_1_size      9
#define fizz_i_2     0x5c
#define fizz_i_2_shift     9
#define fizz_i_2_size      9
#define noise_freq_i     0x60
#define noise_freq_i_shift     0
#define noise_freq_i_size      10
#define slew_in_i     0x60
#define slew_in_i_shift     10
#define slew_in_i_size      3
#define cycle_recycle_i     0x60
#define cycle_recycle_i_shift     13
#define cycle_recycle_i_size      1
#define y_level_i     0x64
#define y_level_i_shift     0
#define y_level_i_size      12
#define cr_level_i     0x64
#define cr_level_i_shift     12
#define cr_level_i_size      12
#define cb_level_i     0x68
#define cb_level_i_shift     0
#define cb_level_i_size      12
#define video_active     0x6c
#define video_active_shift     0
#define video_active_size      1
#define osc_1_freq_i     0x70
#define osc_1_freq_i_shift     0
#define osc_1_freq_i_size      10
#define osc_1_derv_i     0x70
#define osc_1_derv_i_shift     10
#define osc_1_derv_i_size      10
#define sync_sel_osc1_i     0x70
#define sync_sel_osc1_i_shift     20
#define sync_sel_osc1_i_size      2
#define osc_2_freq_i     0x74
#define osc_2_freq_i_shift     0
#define osc_2_freq_i_size      10
#define osc_2_derv_i     0x74
#define osc_2_derv_i_shift     10
#define osc_2_derv_i_size      10
#define sync_sel_osc2_i     0x74
#define sync_sel_osc2_i_shift     20
#define sync_sel_osc2_i_size      2
// Macros for extracting and setting values based on the given specifications 
#define EXTRACT_BITS(value, shift, size) (((value) >> (shift)) & ((1 << (size)) - 1))
#define SET_BITS(value, shift, size, data) ((value) = ((value) & ~(((1 << (size)) - 1) << (shift))) | (((data) & ((1 << (size)) - 1)) << (shift)))




int main() {


    //Tests first 32 digital matrix inputs one at a time
    // Outer loop for matrix_out_addr_int
    for (int matrix_out_addr_val = 40; matrix_out_addr_val < 64; matrix_out_addr_val<<1) {
        // Set matrix_out_addr_int
        SET_BITS(matrix_out_addr_int, matrix_out_addr_int_shift, matrix_out_addr_int_size, matrix_out_addr_val);

        // Inner loop for mask_lower
        for (int mask_lower_val = 0; mask_lower_val < (1 << mask_lower_size); mask_lower_val<<1) {
            // Set mask_lower
            SET_BITS(mask_lower, mask_lower_shift, mask_lower_size, mask_lower_val);

        }
    }

    // then do upper reg
    // then do ++ insted of <<1 to check every posible combo for lower then upper

    return 0;
}

#--------------------------------
# compile options
LOCAL_CFLAGS += -Wall -O3
APP_ABI := all
#--------------------------------
LOCAL_CFLAGS += -D__SENSORS_DEVICE_API_VERSION_0_1__=010
LOCAL_CFLAGS += -D__SENSORS_DEVICE_API_VERSION_1_0__=100
LOCAL_CFLAGS += -D__SENSORS_DEVICE_API_VERSION_1_1__=110
LOCAL_CFLAGS += -D__SENSORS_DEVICE_API_VERSION_1_3__=130

$(warning ----android_version is $(android_version))

ifeq (2.3, $(android_version))
LOCAL_CFLAGS += -D__HAL_VER__=__SENSORS_DEVICE_API_VERSION_0_1__
uncalibrated_virtual_sensor_support = false
significant_motion_sensor_support = false
else ifeq (4.0, $(android_version))
LOCAL_CFLAGS += -D__HAL_VER__=__SENSORS_DEVICE_API_VERSION_0_1__
uncalibrated_virtual_sensor_support = false
significant_motion_sensor_support = false
else ifeq (4.1, $(android_version))
LOCAL_CFLAGS += -D__HAL_VER__=__SENSORS_DEVICE_API_VERSION_0_1__
uncalibrated_virtual_sensor_support = false
significant_motion_sensor_support = false
else ifeq (4.2, $(android_version))
LOCAL_CFLAGS += -D__HAL_VER__=__SENSORS_DEVICE_API_VERSION_0_1__
uncalibrated_virtual_sensor_support = false
significant_motion_sensor_support = false
else ifeq (4.3, $(android_version))
LOCAL_CFLAGS += -D__HAL_VER__=__SENSORS_DEVICE_API_VERSION_1_0__
else ifeq (4.4, $(android_version))
LOCAL_CFLAGS += -D__HAL_VER__=__SENSORS_DEVICE_API_VERSION_1_1__
else ifeq (5.0, $(android_version))
LOCAL_CFLAGS += -D__HAL_VER__=__SENSORS_DEVICE_API_VERSION_1_3__
else
	$(warning ----android_version is not configured)
endif
# bmi160
bma_candidates := bmi160

# bmm150
# bmc050 contains bma250+bmm050
# bmc055 contains bma255+bmm050
# bmc056 contains bma255+bmm050
# bmc150 contains bma255+bmm150
bmm_candidates := bmc050 bmc055 bmc056 bmm150 bmc150 bmm050 amm2 amm3 amm6

# bmi160
bmg_candidates := bmi160

usecase_candidates := ndof m4g imu compass accel_only
ifeq (ndof, $(usecase))
LOCAL_CFLAGS += -D__USECASE_TYPE_NDOF__
else ifeq (compass, $(usecase))
LOCAL_CFLAGS += -D__USECASE_TYPE_COMPASS__
else ifeq (m4g, $(usecase))
LOCAL_CFLAGS += -D__USECASE_TYPE_M4G__
else ifeq (imu, $(usecase))
LOCAL_CFLAGS += -D__USECASE_TYPE_IMU__
else ifeq (accel_only, $(usecase))
LOCAL_CFLAGS += -D__USECASE_TYPE_ACCEL_ONLY__
else
LOCAL_CFLAGS += -D__USECASE_TYPE_NDOF__
endif

ifeq (true, $(uncalibrated_virtual_sensor_support))
LOCAL_CFLAGS += -D__UNCALIBRATED_VIRTUAL_SENSOR_SUPPORT__
endif

ifeq (true, $(significant_motion_sensor_support))
LOCAL_CFLAGS += -D__SIGNIFICANT_MOTION_SENSOR_SUPPORT__
bst_extend_sensor_support ?= true
endif

ifeq (true, $(fast_calibration_feature_automatic_support))
LOCAL_CFLAGS += -D__BMI_FAST_CALIB_FEATURE__
endif

# Bosch extention sensor support: bst_extend_sensor_support
# It will be set to true if significant motion sensor, or double tap sensor, or other accel interrupt generated sensor are supported
ifeq (true, $(bst_extend_sensor_support))
LOCAL_CFLAGS += -D__BST_EXTEND_SENSOR_SUPPORT__
endif

ifeq (true, $(bmp_support))
LOCAL_CFLAGS += -D__PRESSURE_SENSOR_SUPPORT__
endif

$(warning compiling daemon for: $(bma) $(bmm) $(bmg) $(bmc) $(bmi))
# if gyro is not defined, enable simu gyro sensor
# maybe I will use __GYRO_SUPPORT__ in future
ifneq (true, $(gyrosupport))
LOCAL_CFLAGS += -D__CFG_SENSOR_G_EMU__
endif

ifeq (true, $(hybrid_hal))
bypass_acc = true
LOCAL_CFLAGS += -D__HYBRID_HAL__
endif

ifeq (true, $(bypass_acc))
LOCAL_CFLAGS += -DCFG_BYPASS_PROC_CHANNEL_A
endif

ifeq (true, $(acc_input_event))
LOCAL_CFLAGS += -DHW_A_USE_INPUT_EVENT
endif

ifeq (off, $(fast_fmc))
LOCAL_CFLAGS += -D__FMC_OFF__
endif

ifeq (on, $(fast_fmc))
ifneq (ndof, $(usecase))
$(warning ------fast fmc is configured while usecase is not ndof)
endif
endif

ifeq (100Hz, $(fastest_mode))
LOCAL_CFLAGS += -D__FASTEST_MODE_100HZ__
endif

ifeq (true, $(unstandard_sensor_support))
LOCAL_CFLAGS += -D__UNSTANDARD_SENSOR_SUPPORT__
endif

ifeq (true, $(calibration_reset))
LOCAL_CFLAGS += -D__RESET_CALIBRATION_PROFILE__
endif

ifeq (, $(findstring) $(usecase), $(usecase_candidates))
$(warning ---usecase is not configured)
endif

ifeq ($(bmi), bmi160)
LOCAL_CFLAGS += -D__BMI160__
LOCAL_CFLAGS += -DHW_INFO_BITWIDTH_A=16
LOCAL_CFLAGS += -DHW_INFO_BITWIDTH_G=16
#gyro_name = bmg160
#acc_name = bma255
endif

ifeq ($(bmc), bmc055)
bma = bma255
bmm = bmm050
LOCAL_CFLAGS += -D__BMC055__
else ifeq ($(bmc), bmc056)
bma = bma255
bmm = bmm050
LOCAL_CFLAGS += -D__BMC056__
else ifeq ($(bmc), bmc150)
bma = bma255
bmm = bmm150
LOCAL_CFLAGS += -D__BMC150__
endif


# bmm150
ifeq ($(bmm), bmm150)
LOCAL_CFLAGS += -D__BMM150__
else ifeq ($(bmm), amm1)
LOCAL_CFLAGS += -D__AMM201__
else ifeq ($(bmm), amm2)
LOCAL_CFLAGS += -D__AMM202__
else ifeq ($(bmm), amm3)
LOCAL_CFLAGS += -D__AMM203__
else ifeq ($(bmm), amm4)
LOCAL_CFLAGS += -D__AMM204__
else ifeq ($(bmm), amm5)
LOCAL_CFLAGS += -D__AMM205__
else ifeq ($(bmm), amm6)
LOCAL_CFLAGS += -D__AMM206__
endif


# if magnetic sensor is supported
ifneq (, $(bmm))
ifeq ($(softiron_support), true)
LOCAL_CFLAGS += -D__SOFTIRON_SUPPORT__
endif
ifeq ($(hw_2nd_interface_config), true)
LOCAL_CFLAGS += -D__HW_2ND_MAG_INTF_CONFIG__
endif
endif

# use scheduling timestamp as timestamp
ifeq (true, $(scheduling_timestamp_calibrated))
LOCAL_CFLAGS += -D__SCHEDULING_TIMESTAMP_CALIBRATED__
endif

ifeq (true, $(sensor_timestamp_scheduling))
LOCAL_CFLAGS += -D__SENSOR_TIMESTAMP_SCHEDULING__
endif
#======================================
# debug configurations
#======================================
ifeq (true, $(debug_data_log))
LOCAL_CFLAGS += -DCFG_USE_DATA_LOG
endif

ifeq (true, $(data_log_using_ram_buffer))
LOCAL_CFLAGS += -D__RAM_DATA_LOG_SUPPORT__
endif

# quiet, error, warning, notice, information, debug
ifeq (quiet, $(debug_trace_level))
LOCAL_CFLAGS += -DCFG_LOG_LEVEL=LOG_LEVEL_Q
else ifeq (error, $(debug_trace_level))
LOCAL_CFLAGS += -DCFG_LOG_LEVEL=LOG_LEVEL_E
else ifeq (warning, $(debug_trace_level))
LOCAL_CFLAGS += -DCFG_LOG_LEVEL=LOG_LEVEL_W
else ifeq (notice, $(debug_trace_level))
LOCAL_CFLAGS += -DCFG_LOG_LEVEL=LOG_LEVEL_N
else ifeq (information, $(debug_trace_level))
LOCAL_CFLAGS += -DCFG_LOG_LEVEL=LOG_LEVEL_I
else ifeq (debug, $(debug_trace_level))
LOCAL_CFLAGS += -DCFG_LOG_LEVEL=LOG_LEVEL_D
endif

ifeq (file, $(debug_log_method))
LOCAL_CFLAGS += -DCFG_LOG_TO_FILE
LOCAL_CFLAGS += -DCFG_LOG_WITH_TIME
else ifeq (logcat, $(debug_log_method))
LOCAL_CFLAGS += -DCFG_LOG_TO_LOGCAT
endif

ifeq (true,$(debug_timing_accuracy))
LOCAL_CFLAGS += -D__DEBUG_TIMING_ACCURACY__
endif

# debug data log with accuracy information
ifeq (true,$(datalog_with_accuracy))
LOCAL_CFLAGS += -D__DEBUG_DATALOG_WITH_ACCURACY__
endif

ifneq (, $(orientation_filt_coef))
LOCAL_CFLAGS += -DCUST_ORIENTATION_FILT_COEF=$(orientation_filt_coef)
endif

ifneq (, $(orientation_filt_dyna))
LOCAL_CFLAGS += -DCUST_ORIENTATION_FILT_DYNA=$(orientation_filt_dyna)
endif

ifneq (, $(orient_filter_mode))
LOCAL_CFLAGS += -DCUST_ORIENTATION_FILT_MODE=$(orientation_filtermode)
endif

ifneq (, $(magnetic_accuracy_thres))
LOCAL_CFLAGS += -DCUST_MAGNETIC_ACCURACY_THRES=$(magnetic_accuracy_thres)
endif


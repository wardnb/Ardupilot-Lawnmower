local serial_port = 2  -- UART port (SERIALx)
local baud_rate = 115200

-- Initialize serial port
serial:begin(serial_port, baud_rate)

-- Helper function to calculate checksum
local function calculate_checksum(data)
    local checksum = 0
    for i = 1, #data do
        checksum = bit32.bxor(checksum, data:byte(i))
    end
    return checksum
end

-- Send motor command frame
local function send_motor_command(steer, speed)
    -- Construct frame
    local start_frame = string.char(0xCD, 0xAB)  -- 0xABCD in little-endian
    local steer_le = string.char(bit32.band(steer, 0xFF), bit32.rshift(steer, 8))  -- Little-endian steer
    local speed_le = string.char(bit32.band(speed, 0xFF), bit32.rshift(speed, 8))  -- Little-endian speed
    local data = start_frame .. steer_le .. speed_le

    -- Calculate checksum
    local checksum = calculate_checksum(data)
    local checksum_le = string.char(bit32.band(checksum, 0xFF), bit32.rshift(checksum, 8))  -- Little-endian checksum

    -- Send frame
    local frame = data .. checksum_le
    serial:write(serial_port, frame)
end

function update()
    -- Get RC inputs (adjust channel numbers as needed)
    local steer_input = rc:get_pwm(4)  -- Yaw channel
    local speed_input = rc:get_pwm(3)  -- Throttle channel

    -- Map RC inputs to -1000 to 1000 range
    local steer = math.floor((steer_input - 1500) * 2)  -- Assumes 1000-2000 PWM range
    local speed = math.floor((speed_input - 1500) * 2)  -- Assumes 1000-2000 PWM range

    -- Clamp values to valid range
    steer = math.max(-1000, math.min(1000, steer))
    speed = math.max(-1000, math.min(1000, speed))

    -- Send command to hoverboard controller
    send_motor_command(steer, speed)
end

return update, 50  -- Run the script at 50 Hz
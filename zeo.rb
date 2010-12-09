require 'rubygems'
require "serialport"

#params for serial port
port_str = "/dev/tty.usbserial-FTETXWBV"  #may be different for you
baud_rate = 38400 
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)



while true

st = sp.getc
#puts st.chr
if st.chr == 'A' 
    version = sp.getc
    #puts version.chr
    checksum = sp.getc
    length = sp.getc
    length += (sp.getc) << 8
    #puts length
    
    
    lli1 = sp.getc
    lli2 = sp.getc
    
    
    t = sp.getc
    #puts t
    sp.getc
    sp.getc
    seq = sp.getc
    #puts seq
    type = sp.getc
    
    
    
    #puts type.to_s(16) + ' ' + length.to_s
    
    if ( type == 0x83 ) # frequency bin
        #puts 'FREQUENCY BIN ****** '
        7.times do 
            f = sp.getc
            f += (sp.getc) << 8
            f = (f.to_f/10.0).to_i
            print(f.to_s + ' ') 
        end
        puts

    elsif type == 0x80 # Waveform
    
    
        (length-1).times { 
            val = sp.getc
            val += sp.getc << 8
            val = (val.to_f*315)/0x8000 
            #print(val.to_s + ' ')
        }
        
        #puts
        
    elsif type == 0x84 # SQI
    
        sqi = sp.getc
        #puts 'SQI = ' + sqi.to_s
        3.times { sp.getc }

    elsif type == 0x97 # Impedance
    
        impi = sp.getc
        impi += (sp.getc) << 8
        impi -= 0x8000
        
        impq = sp.getc
        impq += (sp.getc) << 8
        impq -= 0x8000
        
        #puts 'impedance = ' + impi.to_s + ' ' + impq.to_s
        
    else
        (length-1).times { sp.getc }
    end

    #puts
end

end


sp.close    

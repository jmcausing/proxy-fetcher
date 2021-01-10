#!/bin/bash
echo "[****] Socks fetcher by John Causing"
echo "[****]"
echo "[****] This bash script will fetch all the latest socks from these websites:"
echo "[****] https://socks-proxy.net"
echo "[****]"
############################


# Check for required apps

# Check if xmllint app exist. If not, then install.
if ! command -v xmllint &> /dev/null
then
   echo "# xmllint is not yet installed"
   echo "# Installing xmllint.."
   sudo apt -y update -qq
   sudo apt -y install libxml2-utils -qq
   
else
   echo "# xmllint is here.."
fi

# Check if tidy app exist. If not, then install.
if ! command -v tidy &> /dev/null
then
   echo "# tidy is not yet installed"
   echo "# Installing tidy.."
   sudo apt -y update -qq
   sudo apt -y install tidy -qq
   
else
   echo "# tidy is here.."
fi



# Get all IPs, ports and type from https://socks-proxy.net"
echo "# Get all IPs, ports and type from https://socks-proxy.net"
echo "#"

# get all IP first and append to ip.txt
wget -q -O - "https://socks-proxy.net" \ | xmllint --html --xpath "//table[@id='proxylisttable']//tr//td[position() = 1]" - 2>/dev/null | tidy -cq -omit -f /dev/null | xmllint --html --xpath "//td/text()" - > ip.txt

# get all ports and append to ports.txt
wget -q -O - "https://socks-proxy.net" \ | xmllint --html --xpath "//table[@id='proxylisttable']//tr//td[position() = 2]" - 2>/dev/null | tidy -cq -omit -f /dev/null | xmllint --html --xpath "//td/text()" - > port.txt


# remove line empty lines
sed -i '/^$/d' ip.txt
sed -i '/^$/d' port.txt

# combine port and ip with ":"
paste ip.txt port.txt  -d : > proxy.txt


while IFS= read -r line
do
                echo "# Testing proxy Sock 4: $line.. ";
                echo "#"
                # timeout 5 curl --socks4 $line -I https://johnmultisite.kinsta.cloud/ &> /dev/null | echo $line >> fresh.txt
                if curl --socks4 $line --max-time 5 'https://google.com' &> /dev/null
                        then                                                                                                                                                                                                                                                                               
                        echo "# Connection for the $line was successful!"; 
                        echo "# ";                                                                                                                                                                                                                                                   
                        echo $line >> working_socks4.txt;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                    else 
                    echo "# Connection failed!"
                    echo "# ";    
                fi

done < proxy.txt



echo "[****]"
echo "[****] Here are your updated socks list. Enjoy!"
tail working_socks4.txt

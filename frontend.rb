require "unirest"
system "clear"
puts "Welcome to the Contacts App!"
puts

while true
  puts "[1] View First Contact"
  puts "[2] View All Contacts"
  puts "[3] View All Contacts, Limited Info"
  puts "[4] View Specific Contact"
  puts "[5] Update a Contact"
  puts "[6] Create a Contact"
  puts "[7] Delete a Contact"
  puts "To quit, type 'q'"
  input = gets.chomp
  puts
  if input == "1" # View First Contact
    response = Unirest.get("http://localhost:3000/v1/first_contact")
    first_name = response.body
    puts JSON.pretty_generate(first_name)
    print "[Enter] To Continue."
    gets.chomp
    system "clear"
  elsif input == "2" # View All Contacts (all info)
    response = Unirest.get("http://localhost:3000/v1/all_contacts")
    all_contacts = response.body
    puts JSON.pretty_generate(all_contacts)
    print "[Enter] To Continue."
    gets.chomp
    system "clear"
  elsif input == "3" # View All Contacts (limited info)
    all_contacts = Unirest.get("http://localhost:3000/v2/contacts").body
    puts JSON.pretty_generate(all_contacts)
    print "[Enter] To Continue."
    gets.chomp
    system "clear"
  elsif input == "4" # View specific contact
    print "Enter id: "
    id = gets.chomp
    puts
    response = Unirest.get("http://localhost:3000/v2/contacts/#{id}")
    body = response.body
    status = response.code
    if status == 500
      puts "***Contact Does Not Exist***"
      print "Any Key to Continue, 'q' to Quit: "
      entry = gets.chomp
      if entry == 'q'
        break
      end
      system "clear"
      next
    end
    puts JSON.pretty_generate(body)
    print "[Enter] To Continue."
    gets.chomp
    system "clear"
  elsif input == "5" # Update Contact
    print "Enter id: "
    id = gets.chomp
    body = Unirest.get("http://localhost:3000/v2/contacts/#{id}").body
    params = {}
    print "First Name: (#{body['first_name']}) "
    params["first_name"] = gets.chomp
    print "Middle Name: (#{body['middle_name']}) "
    params["middle_name"] = gets.chomp
    print "Last Name: (#{body['last_name']}) "
    params["last_name"] = gets.chomp
    print "Bio: (#{body['bio']}) "
    params["bio"] = gets.chomp
    print "Email: (#{body['email']}) "
    params["email"] = gets.chomp
    print "Phone Number: (#{body['phone_number']}) "
    params["phone_number"] = gets.chomp
    params.delete_if { |_key, value| value.empty? }
    body = Unirest.patch("http://localhost:3000/v2/contacts/#{id}", parameters: params).body
    puts JSON.pretty_generate(body)
    print "[Enter] To Continue."
    gets.chomp
    system "clear"
  elsif input == "6" # Create contact
    params = {}
    print "First Name: "
    params["first_name"] = gets.chomp
    print "Middle Name: "
    params["middle_name"] = gets.chomp
    print "Last Name: "
    params["last_name"] = gets.chomp
    print "Bio: "
    params["bio"] = gets.chomp
    print "Email: "
    params["email"] = gets.chomp
    print "Phone Number: "
    params["phone_number"] = gets.chomp
    body = Unirest.post("http://localhost:3000/v2/contacts/", parameters: params).body
    puts JSON.pretty_generate(body)
    puts "Contact Successfully Created!"
    print "[Enter] To Continue."
    gets.chomp
    system "clear"
  elsif input == "7" # Delete contact
    print "Enter id: "
    id = gets.chomp
    puts
    response = Unirest.get("http://localhost:3000/v2/contacts/#{id}")
    body = response.body
    status = response.code
    if status == 500
      puts "***Contact Does not Exist***"
      print "Any Key To Continue, 'q' to Quit: "
      entry = gets.chomp
      if entry == "q"
        break
      end
      system "clear"
      next
    end
    puts JSON.pretty_generate(body)
    print "Are you sure you want to delete this contact? [Y/N]: "
    confirmation = gets.chomp
    if confirmation == "Y" || confirmation == "y"
      body = Unirest.delete("http://localhost:3000/v2/contacts/#{id}").body
      puts body["message"]
    end
    print "[Enter] To Continue."
    gets.chomp
    system "clear"
  elsif input == "q"
    break
  end
end


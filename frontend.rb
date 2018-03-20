require "unirest"
require "tty-prompt"

while true
  system "clear"
  puts "Welcome to the Contacts App!"
  puts
  puts "[Enter] To Signup"
  puts "[Login] To Login"
  puts "[In?] To check login status"
  puts "[1] View First Contact"
  puts "[2] View All Contacts"
  puts "[3] View All Contacts, Limited Info"
  puts "[4] View Specific Contact"
  puts "[5] Search All Contacts"
  puts "[6] Update a Contact"
  puts "[7] Create a Contact"
  puts "[8] Delete a Contact"
  puts "[Logout] to Logout"
  puts "To quit, type 'q'"
  input = gets.chomp
  puts

  if input == ""
    prompt = TTY::Prompt.new
    params = {}
    print "Enter name: "
    params[:name] = gets.chomp
    print "Enter email: "
    params[:email] = gets.chomp
    params[:password] = prompt.mask "Enter password: "
    params[:password_confirmation] =  prompt.mask "Enter password again: "
    response = Unirest.post("http://localhost:3000/v2/users", parameters: params)
    body = response.body
    puts JSON.pretty_generate(body)
    puts
    print "[Enter] to continue: "
    gets.chomp
  elsif input == "Login" or input == "login"
    prompt = TTY::Prompt.new
    print "Enter email: "
    email = gets.chomp
    password = prompt.mask "Enter password: "
    response = Unirest.post(
      "http://localhost:3000/user_token",
      parameters: {
        auth: {
          email: email,
          password: password
        }
      }
    )

    # Save the JSON web token from the response
    jwt = response.body["jwt"]
    # Include the jwt in the headers of any future web requests
    Unirest.default_header("Authorization", "Bearer #{jwt}")
    puts "You are now logged in and your jwt is #{jwt}"
    print "[Enter] to continue: "
    gets.chomp
  elsif input == "Logout" or input == "logout"
    jwt = ""
    Unirest.clear_default_headers()
    print "You are now logged out. [Enter] to continue: "
    gets.chomp
  elsif input == "in?" or input == "In?" or input == "in"
    body = Unirest.get("http://localhost:3000/v2/contacts").body
    if body[0]
      id = body[0]["user_id"].to_i
    else
      id = body["user_id"].to_i
    end
    body = Unirest.get("http://localhost:3000/v2/users/#{id}").body
    if body["email"]
      puts "You are currently logged in under the username: #{body["email"]}"
    else
      puts "You are not currently logged in"
    end
    print "Enter to continue: "
    gets.chomp
  elsif input == "1" # View First Contact
    response = Unirest.get("http://localhost:3000/v1/first_contact")
    first_name = response.body
    puts JSON.pretty_generate(first_name)
    print "[Enter] To Continue."
    gets.chomp
  elsif input == "2" # View All Contacts (all info)
    response = Unirest.get("http://localhost:3000/v1/all_contacts")
    all_contacts = response.body
    puts JSON.pretty_generate(all_contacts)
    print "[Enter] To Continue."
    gets.chomp
  elsif input == "3" # View All Contacts (limited info)
    all_contacts = Unirest.get("http://localhost:3000/v2/contacts").body
    puts JSON.pretty_generate(all_contacts)
    print "[Enter] To Continue."
    gets.chomp
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
  elsif input == "5" # Search Contacts
    while true
      print "Enter Search Term: "
      search = gets.chomp
      response = Unirest.get("http://localhost:3000/v2/contacts?search=#{search}")
      page = response.body
      puts JSON.pretty_generate(page)
      puts
      print "[Enter] to search again, [1] to return to main menu: "
      if gets.chomp == "1"
        break
      end
    end
  elsif input == "6" # Update Contact
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
    if body["errors"] != nil
      puts
      puts "*****"
      puts "There was an error"
      puts "*****"
      puts body["errors"]
    else
      puts JSON.pretty_generate(body)
    end
    puts
    print "[Enter] To Continue."
    gets.chomp
  elsif input == "7" # Create contact
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
    if body["errors"] != nil
      puts
      puts "*****"
      puts "There was an error"
      puts "*****"
      puts body["errors"]
    else
      puts "*****"
      puts "Contact Successfully Created!"
      puts "*****"
      puts
      puts JSON.pretty_generate(body)
    end
    puts
    print "[Enter] To Continue."
    gets.chomp
  elsif input == "8" # Delete contact
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
  elsif input == "q"
    break
  end
end


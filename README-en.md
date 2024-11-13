# IPFetcher
You can choose the README language:
- [Português (BR)](README.md)
- [English (EN)](README-en.md)
IPFetcher is a practical and efficient tool designed to validate the response of IP addresses directly in an application.

To use it, you need to search for a specific range of target IPs and compile a list of these addresses. The goal is to check if the IPs have active web services on ports 80 or 443. Additionally, if an application is found, the tool will allow you to test access through a specific path.

## Installation

Make sure you have `curl` installed on your system:

```bash
sudo apt-get install curl  # For Debian/Ubuntu
```
## Download the script:
```
curl -O https://raw.githubusercontent.com/yourusername/yourrepo/master/IPFetcher.sh
chmod +x IPFetcher.sh
```

## Usage

Simple execution:<br>
`./IPFetcher.sh -iL ip.txt`

Forced execution via HTTPS:<br>
`./IPFetcher.sh -iL ip.txt -iS`

Execution specifying a unique application path:<br>
`./IPFetcher.sh -iL ip.txt -iS -P "/WebSrv/admin/"`

Forced execution via HTTPS, filtering only responses with the mentioned status codes:<br>
`./IPFetcher.sh -iL ip.txt -iS -sc 200,302,401`

Forced execution via HTTPS, setting a maximum timeout:<br>
`./IPFetcher.sh -iL ip.txt -iS -t 10`

Forced execution via HTTPS, specifying ports:<br>
`./IPFetcher.sh -iL ip.txt -iS --ports 443,8080,8088`

Forced execution via HTTPS, using Top Portas.<br>
`./IPFetcher.sh -iL ip.txt -iS --top-ports 5`
`./IPFetcher.sh -iL ip.txt -iS --top-ports=5`

```
Options:
    Usage: ./IPFetcher.sh -iL <file_with_ips> [-iS] [-iV] ​​[-P <path>] [-U <url>] [-t <timeout>] [-v|-- verbose] [ -sc <status_codes>] [--ports <ports>] [-iP]
        -iL <file_with_ips> : Text file containing IPs.
        -iS: Makes HTTPS requests.
        -iV : Replaces the URL hostname with the IP (must be used with -U).
        -P <path>: The path to be used in requests, and filled inside the quotation marks.
        -U <url>: A complete URL to make requests (ex: https://lab.net/admin).
        -sc <status_codes> : Filters returns to show only specified statuses (ex: 200,404).
        -t <timeout> : Maximum time in seconds for the request. Default time 30 seconds.
        -v|--verbose : Enables the display of detailed information.
        -h|--help : Display this help.
        --ports <ports> : One or more comma-separated ports to test (e.g. 80,443,8080).
        --top-port <number>: number of top ports to test. Ex: --top-port 5 or --top-port=5
        -iP : Use standard ports (443 8080 8081) for IPs when not specified with --ports.
```

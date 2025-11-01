# jellifinflix

**jellifinflix** is a downstream fork of [safiyu/jellifinflix](https://github.com/safiyu/jellifinflix), enhanced to allow running as many maintenance scripts as needed against a single Jellyfin library.  The idea is that a Jellyfin admin may want to run a couple of simple helper scripts against their library on a scheduled basis, and this service will take care of that for them.

The `entry.sh` script will run all scripts located in the `/scripts.d` directory inside the container.  You can add your own scripts by adding them to the `scripts` directory in the repository before building the Docker image.  It is highly recommended to follow the format of the existing included scripts, specifically to be run from the `/media` directory directly.  The script will one at a time copy each script into that directory and then `cd` to it and run it, and remove it after the fact.

When adding a new script, just name it with a prefix number to control the order in which it is run.  For example, a script named `05-some-script.sh` will run before `10-another-script.sh`.

### Included Scripts
- **00-set-ignore-file.sh**: This script will create `.ignore` files in any subdirectory of the media library that does not contain any video files.
- **10-remove-unwanted-subtitles.sh**: This script will remove any unwanted subtitle files from the media library, based on a predefined list of languages. The included script is set to English only, but you can modify the regex in the script to handle other languages as needed.  By default this script has a flag set to run in delete mode, if you do decide to leave this script I would suggest first changing that flag in your fork to `0` to run in dry-run mode and see what files it would delete before actually deleting them.  Update it back to `1` when you are comfortable with the results.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Sphexi/jellifinflix.git
   cd jellifinflix
   ```

2. **Update the docker-compose.yaml file:**

   - Update `volumes` to match your local media directory.  If your media directory is `/share/Media`, you would set it to:

     ```yaml
     volumes:
       - /share/Media:/media:rw
     ```
   - It's important that the path inside the container remains `/media`, as the scripts rely on this path.
   - Optional: Set the `JF_API_KEY` environment variable to an API key from Jellyfin (Dashboard -> Advanced -> API Keys).
   - Optional: Set the `JF_URL` environment variable to the URL or IP address for your Jellyfin server (ie `jellyfin.domain.com` or `192.168.123.123`).

   ***Note:*** If you leave the API fields blank, the script will simply bypass the API call to force a rescan of media after each run.  This may cause delays in Jellyfin dropping empty directories, but it will still eventually work.

2. **Build and run the Docker container:**

   ```bash
   docker compose up -d --build
   ```

This command builds the Docker image and starts the container in detached mode.


## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
# Sound Assets

This directory contains audio files for the Worry vs Fear game.

## Required Files

1. **success.mp3** - Played when user correctly categorizes a scenario
   - Suggested: Short, pleasant chime (0.5-1 second)
   - Volume: Moderate

2. **error.mp3** - Played when user incorrectly categorizes a scenario
   - Suggested: Soft, non-harsh buzz (0.3-0.5 second)
   - Volume: Moderate

3. **celebration.mp3** - Played on game completion
   - Suggested: Triumphant fanfare or applause (1-2 seconds)
   - Volume: Moderate

## Free Sound Sources

You can download royalty-free sounds from:

- <https://freesound.org/>
- <https://mixkit.co/free-sound-effects/>
- <https://www.zapsplat.com/>
- <https://notificationsounds.com/>

## Implementation

The `AudioServiceImpl` class uses the `audioplayers` package to play these files.
Files should be in MP3 format for cross-platform compatibility.

## Testing Without Sounds

The app will still work without sound files - audio errors are caught and logged gracefully.

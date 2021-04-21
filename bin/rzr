#!/usr/bin/env python

from colour import Color
from openrazer.client import DeviceManager
from openrazer.client import constants as razer_constants
from pathlib import Path

import argparse
import os
import time
import toml


def get_color_tuple(color_string):

    # Convert color string to RGB tuple
    try:
        color = Color(color_string).rgb
    except:
        raise Exception("'{}' is not a valid color".format(color_string))

    # Scale RGB tuple from [0, 1] to [0, 255]
    color_tuple = tuple(map(lambda x: int(x * 255), color))

    return color_tuple


def apply_lightmap(device_profile):

    global device_manager, lightmap_directory

    # Get openrazer device
    device = next(
        (
            d
            for d in device_manager.devices
            if d.name.lower() == device_profile["name"].lower()
        ),
        None,
    )
    if device == None:
        print("device '{}' not found".format(device_profile["device"]))
        exit(1)

    # Open lightmap
    try:
        lightmap = toml.load(
            "{}/{}.toml".format(lightmap_directory, device_profile["lightmap"])
        )
    except FileNotFoundError:
        print("the lightmap '{}' doesn't exist".format(device_profile["lightmap"]))
        if len(os.listdir(lightmap_directory)) > 0:
            print("found the following lightmaps:")
            for lightmap_file in os.listdir(lightmap_directory):
                print("  - {}".format(lightmap_file[:-5]))
        else:
            print("found no lightmaps")
        exit(1)
    except Exception as e:
        print("failed to load lightmap '{}': {}".format(device_profile["lightmap"], e))
        exit(1)

    # Set light colors
    try:
        for light in device_profile["lights"]:
            color_tuple = get_color_tuple((device_profile["lights"][light]))
            device.fx.advanced.matrix[
                lightmap[light][0], lightmap[light][1]
            ] = color_tuple
    except KeyError:
        print(
            "light '{}' is not available in lightmap '{}'".format(
                light, device_profile["lightmap"]
            )
        )
        exit(1)
    except Exception as e:
        print("failed to set light '{}': {}".format(light, e))
        exit(1)

    # Apply light colors
    device.fx.advanced.draw()


def iterate_lights():

    global device_manager

    # Print number of devices
    print("found the following devices:")
    for device in device_manager.devices:
        print("  - {}".format(device.name))

    # Turn all lights off
    for device in device_manager.devices:
        device.fx.none()
        device.fx.advanced.draw()

    # Iterate through device matrices and turn on one light every second
    for device in device_manager.devices:

        # Wait five seconds
        for i in range(5, 0, -1):
            print("{} will be iterated in {} seconds".format(device.name, i))
            time.sleep(1)

        for i in range(device.fx.advanced.rows):
            for j in range(device.fx.advanced.cols):
                device.fx.advanced.matrix[i, j] = (255, 255, 255)
                device.fx.advanced.draw()
                print("{}: [{}, {}]".format(device.name, i, j))
                time.sleep(1)


if __name__ == "__main__":

    global device_manager, lightmap_directory

    # Initialise variables
    profile_directory = "{}/.config/rzr/profiles".format(Path.home())
    lightmap_directory = "{}/.config/rzr/lightmaps".format(Path.home())

    # Create config folders if not existent
    Path(profile_directory).mkdir(parents=True, exist_ok=True)
    Path(lightmap_directory).mkdir(parents=True, exist_ok=True)

    # Create device manager
    try:
        device_manager = DeviceManager()
    except Exception as e:
        print("failed to load device manager: {}".format(e))
        print("is the openrazer-daemon running?")
        exit(1)

    # Parse arguments
    parser = argparse.ArgumentParser(
        description="Set color profiles of your Razer devices."
    )
    parser.add_argument(
        "profile",
        metavar="PROFILE",
        nargs="?",
        help="the profile which shall be applied (ignored if --iterate is set)",
    )
    parser.add_argument(
        "-i",
        "--iterate",
        action="store_true",
        help="iterate through all Razer devices and turn on one light after another",
    )
    args = parser.parse_args()

    # Print greeter
    print("rzr")

    if args.iterate:
        iterate_lights()
    elif args.profile:
        # Load profile
        try:
            profile = toml.load("{}/{}.toml".format(profile_directory, args.profile))
        except FileNotFoundError:
            print("the profile '{}' doesn't exist".format(args.profile))
            if len(os.listdir(profile_directory)) > 0:
                print("found the following profiles:")
                for profile_file in os.listdir(profile_directory):
                    print("  - {}".format(profile_file[:-5]))
            else:
                print("found no profiles")
            exit(1)
        except Exception as e:
            print(type(e))
            print("error while loading profile: {}".format(args.profile))
            exit(1)
        for device in profile:
            apply_lightmap(profile[device])

        print("profile '{}' applied".format(args.profile))

    else:
        parser.error("either set a profile or --iterate")

from setuptools import setup

setup(
    name="rzr",
    version="0.0.1",
    author="Denis Lehmann",
    author_email="denis@opaque.tech",
    scripts=["bin/rzr"],
    url="https://git.opaque.tech/denis/rzr",
    license="LICENSE",
    description="A simple command line frontend for OpenRazer.",
    long_description=open("README.org").read(),
    install_requires=["colour", "openrazer", "toml"],
)

from setuptools import setup

setup(
    name="rzr",
    scripts=["./rzr"],
    py_modules=[],
    license="LICENSE",
    description="A simple command line frontend for OpenRazer",
    long_description=open("README.org").read(),
    install_requires=["colour", "openrazer", "toml"],
)

#!/usr/bin/env python3

"""A simple Flask app to demonstrate the use of AWS S3"""

import boto3
from flask import Flask, render_template

app = Flask(__name__)

# AWS S3 configuration
S3_BUCKET_NAME = "bucket-for-aws-lab"
S3_REGION = "eu-central-1"
S3_ACCESS_KEY = ""
S3_SECRET_KEY = ""


s3 = boto3.client(
    "s3",
    region_name=S3_REGION,
    aws_access_key_id=S3_ACCESS_KEY,
    aws_secret_access_key=S3_SECRET_KEY,
)


@app.route("/")
def home():
    """Get the URL of the logo from the S3 bucket"""
    logo_url = get_s3_logo_url("aws-lab/logo1.jpeg")
    return render_template("index.html", message="Hello Commit", logo_url=logo_url)


def get_s3_logo_url(logo_key):
    """Generate a pre-signed URL for the logo"""
    url = s3.generate_presigned_url(
        "get_object",
        Params={"Bucket": S3_BUCKET_NAME, "Key": logo_key},
        ExpiresIn=3600,  # URL expiration time in seconds (adjust as needed)
    )
    return url


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)

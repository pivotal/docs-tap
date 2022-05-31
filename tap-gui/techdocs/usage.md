# TechDocs

This guide explains how to generate and publish TechDocs for catalogs.
For more information, see the [Backstage.io documentation](https://backstage.io/docs/features/techdocs/techdocs-overview).


## <a id="create-s3-bucket"></a> Create an Amazon S3 bucket

To create an Amazon S3 bucket:

1. Go to [Amazon S3](https://s3.console.aws.amazon.com/s3/home).
1. Click **Create bucket**.
1. Give the bucket a name.
1. Select the AWS region.
1. Keep **Block all public access** checked.
1. Click **Create bucket**.


## <a id="configure-s3-access"></a> Configure Amazon S3 access

The TechDocs are published to the S3 bucket that was recently created.
You need an AWS user's access key to read from the bucket when viewing TechDocs.
To configure Amazon S3 access:

1. Create an [AWS IAM User Group](https://console.aws.amazon.com/iamv2/home#/groups):
    1. Click **Create Group**.
    2. Give the group a name.
    3. Click **Create Group**.
    4. Click the new group and navigate to **Permissions**.
    5. Click **Add permissions** and click **Create Inline Policy**.
    6. Click the **JSON** tab and replace contents with this JSON replacing `BUCKET-NAME` with the bucket name.

        ```json
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "ReadTechDocs",
                    "Effect": "Allow",
                    "Action": [
                        "s3:ListBucket",
                        "s3:GetObject"
                    ],
                    "Resource": [
                        "arn:aws:s3:::BUCKET-NAME",
                        "arn:aws:s3:::BUCKET-NAME/*"
                    ]
                }
            ]
        }
        ```

    7. Click **Review policy**.
    8. Give the policy a name and click **Create policy**.

2. Create an [AWS IAM User](https://console.aws.amazon.com/iamv2/home#/users) to add to this group:
   1. Click **Add users**.
   2. Give the user a name.
   3. Verify **Access key - Programmatic access** and click **Next: Permissions**.
   4. Verify the IAM Group to add the user to and click **Next: Tags**.
   5. Click **Next: Review** then click **Create user**.
   6. Record the **Access key ID** (`AWS_READONLY_ACCESS_KEY_ID`) and the **Secret access key** (`AWS_READONLY_SECRET_ACCESS_KEY`) and click **Close**.


## <a id="find-cat-loc-and-entities"></a> Find the catalog locations and their entities' namespace/kind/name

TechDocs are generated for catalogs that have markdown source files for TechDocs.
To find the catalog locations and their entities' namespace/kind/name:

1. The catalogs appearing in Tanzu Application Platform GUI are listed in the config values under `app_config.catalog.locations`.
1. For a given catalog, clone the catalog's repository to the local file system.
1. Find the `mkdocs.yml` that is at the root of the catalog. There is a YAML file describing the catalog at the same level called `catalog-info.yaml`.
1. Record the values for `namespace`, `kind`, and `metadata.name`, and the directory path containing the YAML file.
1. Record the `spec.targets` in that file.
1. Find the namespace/kind</name> for each of the targets:
    1. Navigate to the target's YAML file.
    2. The `namespace` value is the value of `namespace`. If it is not specified, it has the value `default`.
    3. The `kind` value is the value of `kind`.
    4. The `name` value is the value of `metadata.name`.
    5. Record the directory path containing the YAML file.


## <a id="use-techdocs-cli"></a> Use the TechDocs CLI to generate and publish TechDocs

VMware uses `npx` to run the TechDocs CLI, which requires `Node.js` and `npm`.
To generate and publish TechDocs by using the TechDocs CLI:

1. [Download and install Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm).
2. Install `npx` by running:

    ```console
    npm install -g npx
    ```

3. Generate the TechDocs for the root of the catalog by running:

    ```console
    npx @techdocs/cli generate --source-dir DIRECTORY-CONTAINING-THE-ROOT-YAML-FILE --output-dir ./site
    ```

    >**Note:** This creates a temporary `site` directory in your current working directory that contains the generated TechDocs files.

4. Review the contents of the `site` directory to verify the TechDocs were generated successfully.
5. Set environment variables for authenticating with Amazon S3 with an account that has read/write access:

    ```console
    export AWS_ACCESS_KEY_ID=AWS-ACCESS-KEY-ID
    export AWS_SECRET_ACCESS_KEY=AWS-SECRET-ACCESS-KEY
    export AWS_REGION=AWS-REGION
    ```

6. Publish the TechDocs for the root of the catalog to the Amazon S3 bucket you created earlier by running:

    ```console
    npx @techdocs/cli publish --publisher-type awsS3 --storage-name BUCKET-NAME --entity NAMESPACE/KIND/NAME --directory ./site
    ```

    Where `NAMESPACE/KIND/NAME` are the values for `namespace`, `kind`, and `metadata.name` you recorded earlier.
    For example, `default/location/yelb-catalog-info`.

7. For each of the `spec.targets` found earlier, repeat the `generate` and `publish` commands.

    > **Note:** The `generate` command erases the contents of the `site` directory before creating new
    TechDocs files. Therefore, the `publish` command must follow the `generate` command for each target.


## <a id="update-app-config.yaml"></a> Update techdocs section in app-config.yaml to point to the Amazon S3 bucket

Update the config values you used during installation to point to the Amazon S3 bucket that has the published TechDocs files:

1. Add or edit the `techdocs` section under `app_config` in the config values with the following YAML, replacing placeholders with the appropriate values.

    ```yaml
    techdocs:
      builder: 'external'
      publisher:
        type: 'awsS3'
        awsS3:
          bucketName: BUCKET-NAME
          credentials:
            accessKeyId: AWS-READONLY-ACCESS-KEY-ID
            secretAccessKey: AWS-READONLY-SECRET-ACCESS-KEY
          region: AWS-REGION
          s3ForcePathStyle: false
    ```

2. Update your installation from the Tanzu CLI.

  * If you installed Tanzu Application Platform GUI as part of the Tanzu Application Platform package (in other words, if you installed it by running `tanzu package install tap ...`) then run:

      ```console
      tanzu package installed update tap \
        --version PACKAGE-VERSION \
        -f VALUES-FILE
      ```

      Where:

      * `PACKAGE-VERSION` is your package version
      * `VALUES-FILE` is your values file

  * If you installed Tanzu Application Platform GUI as its own package (in other words, if you installed it by running `tanzu package install tap-gui ...`) then run:

      ```console
      tanzu package installed update tap-gui \
        --version PACKAGE-VERSION \
        -f VALUES-FILE
      ```

      Where:

      * `PACKAGE-VERSION` is your package version
      * `VALUES-FILE` is your values file

3. Verify the status of this update by running:

    ```console
    tanzu package installed list
    ```

4. Navigate to the **Docs** section of your catalog and view the TechDocs pages to verify the content is loaded from the S3 bucket successfully.

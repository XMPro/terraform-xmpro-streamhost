# Terraform Module Example module_sh

**IMPORTANT:** Press `Ctrl + Shift + V` to preview the Markdown file in Visual Studio Code.

## Requirements:

* docker - https://www.docker.com/products/docker-desktop/
* shell to run cli - (powershell or bash/etc)
* IDE: vscode (optional)

## Steps to Run the Terraform Configuration:

- Things to consider to update in `main.tf`
    |   properties                          | details                                                                       |
    | --                                    | --                                                                            |
    | `prefix`                              | Specifies the prefix used for all resources.                                  |
    | `environment`                         | Specifies the environment for all resources.                                  |
    | `location`                            | Specifies the Azure location where all resources will be created.             |
    | `imageversion`                        | Specifies the version of the Docker image to use.                             |
    | `name`                                | Specifies the resource names                                                  |
    | `gateway_server_url`                  | The URL of your Data Source (DS) DNS.                                         |
    | `gateway_collection_id`               | The collection ID from your Data Source (DS)                                  |
    | `gateway_secret`                      | The secret key from your Data Source (DS) collection                          |
    | `appinsights_connectionstring`        | [**Optional**] The connection string for Azure Application Insights           |
    | `sh_cpu`                              | Defines the number of CPUs allocated to your container                        |
    | `sh_memory`                           | Defines the amount of memory (in GB) allocated to your container              |
    | `streamhost_container_image`          | [**optional**] Specifies the image to be used for the streamhost instance     |


## Variable Configuration

1. Navigate to the `module_sh/variables.tf` file
2. Update the following security-sensitive variables:
   * `ai_gateway_secret`: The authentication secret for Application Insights integration
   * `default_gateway_secret`: The default secret key for gateway authentication

**Note:** These secrets should be stored securely and never committed to version control.

- Before running the Terraform commands, ensure that you are authorized in Azure by following these steps:
    1. Open a command prompt (CMD) and run `az login`.
    2. You will be prompted to navigate to a URL.
    3. Access the URL in your browser, and you will be asked to enter the code displayed in the CMD.
    4. After entering the code, log in using your email account.
    5. Once logged in, you will receive a confirmation that you are signed in, and you can close the browser.
    6. Select the subscription you will be using. For this project, it is the Visual Studio subscription.

- run the following commands

    | Command             | Description                                                                                             |
    |---------------------|-----------------------------------------------------------------------------                            |
    | `terraform init`    | Initializes the Terraform configuration by downloading necessary plugins and setting up the backend.    |
    | `terraform fmt`     | Formats the Terraform configuration files to a canonical format and style.                              |
    | `terraform validate`| Validates the Terraform configuration files for syntax and internal consistency.                        |
    | `terraform plan`    | Creates an execution plan, showing what actions Terraform will take to achieve the desired state.       |
    | `terraform apply`   | Applies the changes required to reach the desired state of the configuration.                           |
    | `terraform destroy` | Destroys the Terraform-managed infrastructure, reverting all changes made by `terraform apply`.         |

- You can visit the [Azure Portal](https://portal.azure.com/#home) to verify the resources that have been created.




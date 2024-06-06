import fs from "node:fs";
import Config from "@/app/generate/config";

const CWD = process.cwd();
const BOILERPLATE_PATH = CWD + "/src/app/generate/boilerplate.tf";
const BOILERPLATE_SERVICE_PATH = CWD + "/src/app/generate/service_boilerplate.tf";


const generate = async (config: Config): Promise<string> => {
    /**
     *  Responsible for generating the complete terraform code based on the configuration
     *  provided by the user.
     */

    let result = '';

    // Read the contents of the boilerplate file and store it in the result variable
    result += await fs.promises.readFile(BOILERPLATE_PATH, "utf-8");

    // Generate the services definitions
    result += `\n#################
# SERVICES      #
#################`;
    for (const service of Object.values(config.services)) {
        let service_result = await fs.promises.readFile(BOILERPLATE_SERVICE_PATH, "utf-8");
        service_result = service_result.replace(/HERO-INFRA-VAR-SERVICE-NAME/g, service.name);
        result += '\n\n' + service_result;
    }

    // Fill in all variables like HERO-INFRA-VAR-AWS-REGION
    result = result.replace(/HERO-INFRA-VAR-AWS-REGION/g, config.region);

    return result;
}

export default generate;

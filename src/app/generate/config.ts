type ServiceSourceDockerHub = {
    source: 'dockerhub';
    url: string;
}

// type ServiceSourceGithub = {
//     source: 'github';
//     url: string;
// }

// type ServiceSource = ServiceSourceGithub | ServiceSourceDockerHub;
type ServiceSource = ServiceSourceDockerHub;

type Service = {
    name: string; // name should be unique
    source: ServiceSource;
}

type Config = {
    region: string;
    services: {[serviceName: string]: Service};
}

export default Config;

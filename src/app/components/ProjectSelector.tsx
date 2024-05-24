"use server";

import {listProjects} from "@/app/actions/projects";
import NewProjectButton from "@/app/components/NewProjectButton";

const ProjectSelector: React.FC = async () => {
    const projects = await listProjects() || [];

    return (
        <div className={"flex gap-4"}>
            {projects.map(project => (
                <button key={project.id} className={"btn btn-primary"}>{project.id} + {project.name}</button>
            ))}
            <NewProjectButton/>
        </div>
    )
}

export default ProjectSelector;

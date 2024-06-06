'use client';

import {createProject} from "@/app/actions/projects";

export default function NewProjectButton() {
    const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        const form = event.currentTarget as HTMLFormElement;
        const formData = new FormData(form);
        const projectName = formData.get('project_name') as string;
        const projectId = formData.get('project_id') as string;
        await createProject(projectName);
        //@ts-ignore
        document.getElementById('create-project-modal').close();
    }

    return (
        <>
            {/*@ts-ignore*/}
            <button className="btn btn-outline" onClick={() => document.getElementById('create-project-modal').showModal()}>New Project
            </button>
            <dialog id="create-project-modal" className="modal">
                <div className="modal-box">
                    <form method={"dialog"} onSubmit={handleSubmit}>
                        <h3 className="font-bold text-lg">Create a new Project</h3>
                        <button className="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>

                        <div className="sm:col-span-4 mt-2">
                            <label htmlFor="project_name" className="block text-sm font-medium leading-6 text-gray-900">Project
                                Name</label>
                            <div className="mt-2">
                                <div
                                    className="flex rounded-md shadow-sm ring-1 ring-inset ring-gray-300 focus-within:ring-2 focus-within:ring-inset focus-within:ring-indigo-600 sm:max-w-md">
                                    <input type="text" name="project_name" id="project_name"
                                           className="block flex-1 border-0 bg-transparent py-1.5 pl-2 text-gray-900 placeholder:text-gray-400 focus:ring-0 sm:text-sm sm:leading-6"
                                           placeholder="Project A"/>
                                </div>
                            </div>
                        </div>

                        <div className="sm:col-span-4 mt-2">
                            <label htmlFor="project_id" className="block text-sm font-medium leading-6 text-gray-900">Project
                                ID</label>
                            <div className="mt-2">
                                <div
                                    className="flex rounded-md shadow-sm ring-1 ring-inset ring-gray-300 focus-within:ring-2 focus-within:ring-inset focus-within:ring-indigo-600 sm:max-w-md">
                                    <input type="text" name="project_id" id="project_id"
                                           className="block flex-1 border-0 bg-transparent py-1.5 pl-2 text-gray-900 placeholder:text-gray-400 focus:ring-0 sm:text-sm sm:leading-6"
                                           placeholder="project-a"/>
                                </div>
                            </div>
                        </div>

                        <div className="mt-6 flex items-center justify-end gap-x-6">
                            <button className="text-sm font-semibold leading-6 text-gray-900">Cancel</button>
                            <button type="submit"
                                    className="rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Save
                            </button>
                        </div>
                    </form>
                </div>
            </dialog>
        </>
    );
}

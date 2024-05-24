import ProjectSelector from "@/app/components/ProjectSelector";

export default function Home() {
    return (
        <main>
            <div className="container container-xs mx-auto h-screen flex flex-col items-start">
                <div className="navbar bg-base-100 border-b border-b-primary/50">
                    <div className="navbar-start">
                        <button className="btn btn-ghost btn-sm text-lg">Overview</button>
                        <button className="btn btn-ghost btn-sm text-lg">Resources</button>
                    </div>
                </div>
                <div className="text-sm breadcrumbs ml-2">
                    <ul>
                        <li><a>Project Name</a></li>
                        <li><a>Staging Environment</a></li>
                        <li>Overview</li>
                    </ul>
                </div>
                <ProjectSelector/>
            </div>
        </main>
    );
}

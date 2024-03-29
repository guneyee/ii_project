import React, { useEffect, useState } from 'react';
import { ii_demo_backend } from 'declarations/ii_demo_backend';
import { AuthClient } from "@dfinity/auth-client";

function Posts() {
    const actor = ii_demo_backend;
    const [authenticated, setAuthenticated] = useState(false);
    const [postList, setPostList] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    async function authInit() {
        try {
            const authClient = await AuthClient.create();
            setAuthenticated(await authClient.isAuthenticated());
        } catch (error) {
            console.error("Authentication error:", error);
            setError("Error initializing authentication.");
        }
    }

    async function fetchPosts() {
        try {
            const posts = await actor.getPosts();
            setPostList(posts);
            setLoading(false);
        } catch (error) {
            console.error("Error fetching posts:", error);
            setError("Error fetching posts.");
            setLoading(false);
        }
    }

    useEffect(() => {
        authInit();
        fetchPosts();
    }, []);

    if (loading) {
        return <div>Loading...</div>;
    }

    if (error) {
        return <div>Error: {error}</div>;
    }

    const showPosts = postList.map((post, index) => (
        <div key={index}>
            <h3>{post.author.toString()}</h3>
            <p>{post.content}</p>
        </div>
    ));

    if (!authenticated) {
        return <div>Please login to see content..</div>;
    }

    return <div>{showPosts}</div>;
}

export default Posts;

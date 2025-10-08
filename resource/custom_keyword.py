from robot.api.deco import keyword
from sentence_transformers import SentenceTransformer, util

# Load lightweight embedding model for semantic comparison
model = SentenceTransformer('paraphrase-MiniLM-L6-v2')

@keyword("Validate Semantic Similarity")
def validate_semantic_similarity(response_text, expected_text, threshold: float = 0.50):
    """Checks that AI response semantically matches the expected meaning."""
    emb1 = model.encode(response_text, convert_to_tensor=True)
    emb2 = model.encode(expected_text, convert_to_tensor=True)
    similarity = float(util.pytorch_cos_sim(emb1, emb2))
    if similarity < threshold:
        raise AssertionError(f"Semantic similarity too low ({similarity:.2f} < {threshold})")
    return True
